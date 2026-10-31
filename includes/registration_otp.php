<?php
require_once __DIR__ . '/auth.php';

function registration_mail_ready(): bool {
    $c = require __DIR__ . '/../config/mail.php';
    return function_exists('curl_init') && filter_var($c['gmail_address'], FILTER_VALIDATE_EMAIL)
        && trim($c['gmail_app_password']) !== '';
}

function registration_send_mail(string $email, string $code): void {
    $c = require __DIR__ . '/../config/mail.php';
    if (!registration_mail_ready() || !filter_var($email, FILTER_VALIDATE_EMAIL)
        || preg_match('/[\r\n]/', $email . $c['gmail_address'])) throw new RuntimeException('Mail configuration unavailable');
    $body = "Mã xác minh đăng ký Fish Shop: $code\n\nMã có hiệu lực 5 phút và chỉ dùng một lần. Không chia sẻ mã với bất kỳ ai.\nNếu bạn không yêu cầu tạo tài khoản, hãy bỏ qua thư này.";
    $message = 'From: Fish Shop <' . $c['gmail_address'] . ">\r\nTo: <" . $email . ">\r\n"
        . "Subject: Fish Shop - Ma xac minh dang ky\r\nMIME-Version: 1.0\r\n"
        . "Content-Type: text/plain; charset=UTF-8\r\nContent-Transfer-Encoding: base64\r\n\r\n" . chunk_split(base64_encode($body));
    $stream = fopen('php://temp', 'r+');
    fwrite($stream, $message); rewind($stream);
    $ch = curl_init('smtps://smtp.gmail.com:465');
    try {
        curl_setopt_array($ch, [CURLOPT_USERNAME => $c['gmail_address'], CURLOPT_PASSWORD => str_replace(' ', '', $c['gmail_app_password']),
            CURLOPT_MAIL_FROM => $c['gmail_address'], CURLOPT_MAIL_RCPT => [$email], CURLOPT_UPLOAD => true,
            CURLOPT_INFILE => $stream, CURLOPT_INFILESIZE => strlen($message), CURLOPT_RETURNTRANSFER => true,
            CURLOPT_CONNECTTIMEOUT => 10, CURLOPT_TIMEOUT => 25, CURLOPT_SSL_VERIFYPEER => true, CURLOPT_SSL_VERIFYHOST => 2]);
        if (curl_exec($ch) === false) throw new RuntimeException('SMTP delivery failed');
    } finally { curl_close($ch); fclose($stream); }
}

function registration_quota(PDO $pdo, string $key, int $limit, int $spacing = 0): bool {
    $key = hash('sha256', $key); $now = time();
    $pdo->beginTransaction();
    try {
        $pdo->prepare('INSERT IGNORE INTO registration_rate_limits VALUES (?, ?, 0, 0)')->execute([$key, $now]);
        $st = $pdo->prepare('SELECT * FROM registration_rate_limits WHERE bucket = ? FOR UPDATE');
        $st->execute([$key]); $row = $st->fetch();
        $hits = $now - (int)$row['started_at'] >= 3600 ? 0 : (int)$row['hits'];
        $ok = $hits < $limit && $now - (int)$row['last_at'] >= $spacing;
        if ($ok) $pdo->prepare('UPDATE registration_rate_limits SET started_at = ?, last_at = ?, hits = ? WHERE bucket = ?')
            ->execute([$hits === 0 ? $now : $row['started_at'], $now, $hits + 1, $key]);
        $pdo->commit(); return $ok;
    } catch (Throwable $e) { if ($pdo->inTransaction()) $pdo->rollBack(); throw $e; }
}

function registration_issue(PDO $pdo, array $data, string $ip, ?callable $mailer = null): array {
    // Optional transport injection is only used by CLI tests, never taken from a request.
    if ($mailer === null && !registration_mail_ready()) throw new DomainException('Gửi mã qua email chưa được bật. Bạn có thể đăng ký bằng Google.');
    if (!registration_quota($pdo, 'ip:' . $ip, 20)
        || !registration_quota($pdo, 'email:' . $data['email'], 5, 60)) {
        throw new DomainException('Vui lòng chờ ít nhất 60 giây. Mỗi email được nhận tối đa 5 mã/giờ.');
    }
    $token = bin2hex(random_bytes(32));
    $hash = hash('sha256', $token);
    $code = sprintf('%06d', random_int(0, 999999));
    $pdo->prepare('INSERT INTO registration_otps (email, challenge_hash, code_hash, expires_at, attempts) VALUES (?, ?, ?, ?, 0)
        ON DUPLICATE KEY UPDATE challenge_hash = VALUES(challenge_hash), code_hash = VALUES(code_hash), expires_at = VALUES(expires_at), attempts = 0')
        ->execute([$data['email'], $hash, password_hash($code, PASSWORD_DEFAULT), time() + 300]);
    try { ($mailer ?? 'registration_send_mail')($data['email'], $code); }
    catch (Throwable $e) {
        $pdo->prepare('DELETE FROM registration_otps WHERE challenge_hash = ?')->execute([$hash]);
        error_log('FishShop: registration OTP delivery failed. Check Gmail SMTP configuration.');
        throw new DomainException('Chưa gửi được mã xác minh. Vui lòng thử lại sau hoặc đăng ký bằng Google.');
    }
    return ['data' => $data, 'token' => $token, 'expires_at' => time() + 300, 'created_at' => time()];
}

function registration_complete(PDO $pdo, array $pending, string $code): int {
    if (empty($pending['token']) || !is_array($pending['data'] ?? null)) throw new DomainException('Vui lòng nhập thông tin đăng ký trước.');
    $data = $pending['data'];
    $pdo->beginTransaction();
    try {
        $st = $pdo->prepare('SELECT * FROM registration_otps WHERE challenge_hash = ? FOR UPDATE');
        $st->execute([hash('sha256', $pending['token'])]); $row = $st->fetch();
        if (!$row || $row['email'] !== $data['email'] || (int)$row['expires_at'] <= time()
            || (int)$row['attempts'] >= 5) throw new DomainException('Mã đã hết hạn, đã dùng hoặc đã sai 5 lần. Vui lòng gửi mã mới.');
        if (!preg_match('/^[0-9]{6}$/D', $code) || !password_verify($code, $row['code_hash'])) {
            $pdo->prepare('UPDATE registration_otps SET attempts = attempts + 1 WHERE challenge_hash = ?')->execute([$row['challenge_hash']]);
            $pdo->commit();
            throw new DomainException('Mã xác minh không đúng. Còn ' . (4 - (int)$row['attempts']) . ' lần thử.');
        }
        $st = $pdo->prepare('SELECT id FROM users WHERE username = ? OR email = ?');
        $st->execute([$data['username'], $data['email']]);
        if ($st->fetch()) throw new DomainException('Tên đăng nhập hoặc email đã được sử dụng. Vui lòng sửa thông tin hoặc đăng nhập.');
        $pdo->prepare("INSERT INTO users (username, password, fullname, email, phone, address, role)
            VALUES (?, ?, ?, ?, ?, ?, 'customer')")
            ->execute([$data['username'], $data['password_hash'], $data['fullname'], $data['email'], $data['phone'],
                $data['address']]);
        $id = (int)$pdo->lastInsertId();
        ensure_rank_profile($pdo, $id);
        $pdo->prepare('DELETE FROM registration_otps WHERE challenge_hash = ?')->execute([$row['challenge_hash']]);
        $pdo->commit(); return $id;
    } catch (Throwable $e) { if ($pdo->inTransaction()) $pdo->rollBack(); throw $e; }
}

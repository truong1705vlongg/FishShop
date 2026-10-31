<?php
require_once __DIR__ . '/includes/firebase_auth.php';
header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, private');
function firebase_reply(int $status, array $data): void {
    http_response_code($status);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}
if ($_SERVER['REQUEST_METHOD'] !== 'POST') firebase_reply(405, ['ok' => false, 'message' => 'Yêu cầu không hợp lệ.']);
if (!csrf_ok()) firebase_reply(403, ['ok' => false, 'message' => 'Phiên làm việc hết hạn. Vui lòng tải lại trang.']);
if (isLoggedIn()) firebase_reply(200, ['ok' => true, 'redirect' => url('index.php')]);
if (time() - (int)($_SESSION['firebase_last_attempt'] ?? 0) < 2) firebase_reply(429, ['ok' => false, 'message' => 'Vui lòng chờ vài giây rồi thử lại.']);
$_SESSION['firebase_last_attempt'] = time();
try {
    $info = verify_firebase_google_token(post_string('id_token'));
    // Google sign-in also creates a customer account on the first visit.
    $id = google_account_id(db(), $info, true);
    $st = db()->prepare("SELECT id FROM users WHERE id = ? AND account_status = 'active'");
    $st->execute([$id]);
    if (!$st->fetchColumn()) throw new DomainException('Tài khoản đang bị khóa. Vui lòng liên hệ quản trị viên.');
    session_regenerate_id(true);
    unset($_SESSION['csrf'], $_SESSION['password_recovery'], $_SESSION['google_login']);
    $_SESSION['user_id'] = $id;
    firebase_reply(200, ['ok' => true, 'redirect' => url('index.php')]);
} catch (DomainException $e) {
    firebase_reply(401, ['ok' => false, 'message' => $e->getMessage()]);
} catch (Throwable $e) {
    error_log('FishShop: Firebase login failed (' . get_class($e) . ').');
    firebase_reply(503, ['ok' => false, 'message' => 'Chưa thể kết nối đăng nhập. Vui lòng thử lại hoặc dùng mật khẩu.']);
}

<?php
require_once __DIR__ . '/auth.php';

function payos_config(): array { return require __DIR__ . '/../config/payos.php'; }
function payos_ready(): bool {
    $c = payos_config();
    return function_exists('curl_init') && $c['client_id'] !== '' && $c['api_key'] !== '' && $c['checksum_key'] !== '';
}
function payos_http(string $method, string $path, ?array $body = null): array {
    $c = payos_config();
    if (!payos_ready()) throw new RuntimeException('PayOS chưa được cấu hình.');
    $ch = curl_init('https://api-merchant.payos.vn' . $path);
    $headers = ['x-client-id: ' . $c['client_id'], 'x-api-key: ' . $c['api_key'], 'Content-Type: application/json'];
    curl_setopt_array($ch, [CURLOPT_CUSTOMREQUEST => $method, CURLOPT_HTTPHEADER => $headers,
        CURLOPT_RETURNTRANSFER => true, CURLOPT_CONNECTTIMEOUT => 10, CURLOPT_TIMEOUT => 25,
        CURLOPT_SSL_VERIFYPEER => true, CURLOPT_SSL_VERIFYHOST => 2]);
    if ($body !== null) curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($body, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
    try {
        $raw = curl_exec($ch);
        if ($raw === false) throw new RuntimeException('PayOS connection failed.');
        $status = curl_getinfo($ch, CURLINFO_RESPONSE_CODE);
        $data = json_decode($raw, true, 32, JSON_THROW_ON_ERROR);
        if ($status < 200 || $status >= 300 || !is_array($data) || ($data['code'] ?? '') !== '00') {
            error_log('FishShop PayOS API error, HTTP ' . $status . ', code ' . (is_array($data) ? (string)($data['code'] ?? 'unknown') : 'invalid'));
            throw new RuntimeException('PayOS không tạo được yêu cầu thanh toán.');
        }
        return $data;
    } finally { curl_close($ch); }
}
function payos_create_order_link(int $orderId): string {
    $pdo = db();
    $st = $pdo->prepare("SELECT o.*, u.fullname, u.email FROM orders o JOIN users u ON u.id = o.user_id WHERE o.id = ? AND o.payment_method = 'payos'");
    $st->execute([$orderId]); $order = $st->fetch();
    if (!$order || $order['status'] === 'cancelled' || $order['payment_status'] === 'paid') throw new DomainException('Đơn hàng không thể thanh toán.');
    if (!empty($order['payos_checkout_url'])) return $order['payos_checkout_url'];
    $c = payos_config();
    if (!payos_ready() || !preg_match('#^https?://#i', $c['base_url'])) throw new RuntimeException('PayOS hoặc URL cửa hàng chưa được cấu hình.');
    $amount = (int)$order['total'];
    if ($amount < 2000 || $amount > 500000000) throw new DomainException('Số tiền đơn hàng không nằm trong giới hạn PayOS.');
    // Keep the return page identical to the page that embeds PayOS Checkout.
    $returnUrl = $c['base_url'] . '/payment.php?id=' . $orderId;
    $cancelUrl = $returnUrl;
    $description = 'FS' . $orderId;
    // A new PayOS request needs a fresh orderCode. Webhooks are correlated by the
    // paymentLinkId saved on this FishShop order, so retries remain safe.
    $payosOrderCode = random_int(100000000, 999999999);
    $signatureData = ['amount' => $amount, 'cancelUrl' => $cancelUrl, 'description' => $description,
        'orderCode' => $payosOrderCode, 'returnUrl' => $returnUrl];
    ksort($signatureData);
    $signing = implode('&', array_map(static fn($key, $value) => $key . '=' . $value, array_keys($signatureData), array_values($signatureData)));
    $payload = $signatureData + ['signature' => hash_hmac('sha256', $signing, $c['checksum_key']),
        'buyerName' => mb_substr($order['fullname'], 0, 100), 'buyerEmail' => $order['email'] ?: null,
        'buyerPhone' => $order['phone'], 'items' => [['name' => 'Đơn hàng Fish Shop #' . $orderId, 'quantity' => 1, 'price' => $amount]]];
    $result = payos_http('POST', '/v2/payment-requests', $payload);
    $data = $result['data'] ?? [];
    if (!is_string($data['checkoutUrl'] ?? null) || !filter_var($data['checkoutUrl'], FILTER_VALIDATE_URL)
        || !str_starts_with($data['checkoutUrl'], 'https://pay.payos.vn/')
        || !is_string($data['paymentLinkId'] ?? null) || $data['paymentLinkId'] === '') {
        throw new RuntimeException('PayOS trả về thông tin thanh toán không hợp lệ.');
    }
    $pdo->prepare("UPDATE orders SET payos_payment_link_id = ?, payos_checkout_url = ? WHERE id = ? AND payment_status <> 'paid'")
        ->execute([$data['paymentLinkId'], $data['checkoutUrl'], $orderId]);
    return $data['checkoutUrl'];
}
function payos_cancel_order_link(int $orderId): void {
    $pdo = db();
    $st = $pdo->prepare("SELECT payos_payment_link_id, payment_status, status FROM orders WHERE id = ? AND payment_method = 'payos'");
    $st->execute([$orderId]); $order = $st->fetch();
    if (!$order || $order['status'] === 'cancelled' || !in_array($order['payment_status'], ['unpaid', 'rejected'], true)) {
        throw new DomainException('Đơn này không thể tạo lại mã thanh toán.');
    }
    $linkId = (string)($order['payos_payment_link_id'] ?? '');
    if ($linkId === '') return;

    $path = '/v2/payment-requests/' . rawurlencode($linkId);
    try {
        $result = payos_http('POST', $path . '/cancel', ['cancellationReason' => 'Customer requested a new QR']);
        $data = $result['data'] ?? [];
        if (($data['status'] ?? '') !== 'CANCELLED') throw new RuntimeException('PayOS did not confirm cancellation.');
    } catch (Throwable $cancelError) {
        // PayOS may report an error if the link was already cancelled. Accept
        // that case only after verifying its current state from PayOS.
        $result = payos_http('GET', $path);
        if (($result['data']['status'] ?? '') !== 'CANCELLED') throw $cancelError;
    }

    $clear = $pdo->prepare("UPDATE orders SET payos_payment_link_id = NULL, payos_checkout_url = NULL WHERE id = ? AND payos_payment_link_id = ? AND payment_status IN ('unpaid','rejected')");
    $clear->execute([$orderId, $linkId]);
    if ($clear->rowCount() !== 1) throw new DomainException('Trạng thái đơn đã thay đổi. Hãy tải lại trang trước khi tạo QR mới.');
}
function payos_sync_order_status(int $orderId): string {
    $pdo = db();
    $st = $pdo->prepare("SELECT payment_status, status, total, payos_payment_link_id FROM orders WHERE id = ? AND payment_method = 'payos'");
    $st->execute([$orderId]); $order = $st->fetch();
    if (!$order || $order['payment_status'] === 'paid' || $order['status'] === 'cancelled'
        || empty($order['payos_payment_link_id']) || !payos_ready()) {
        return (string)($order['payment_status'] ?? 'unpaid');
    }

    // Limit status lookups per session so the order page can poll safely.
    $lastCheck = (int)($_SESSION['payos_status_check'][$orderId] ?? 0);
    if (time() - $lastCheck < 5) return (string)$order['payment_status'];
    $_SESSION['payos_status_check'][$orderId] = time();

    try {
        $linkId = (string)$order['payos_payment_link_id'];
        $result = payos_http('GET', '/v2/payment-requests/' . rawurlencode($linkId));
        $data = $result['data'] ?? [];
        if (($data['id'] ?? '') === $linkId && ($data['status'] ?? '') === 'PAID'
            && (int)($data['amount'] ?? 0) === (int)$order['total']
            && (int)($data['amountPaid'] ?? 0) === (int)$order['total']) {
            // The remote lookup happens outside the transaction. Lock and re-read
            // before writing so cancellation, a new link, or another callback wins safely.
            $pdo->beginTransaction();
            try {
                $currentSt = $pdo->prepare("SELECT payment_status, status, total, payos_payment_link_id FROM orders WHERE id = ? AND payment_method = 'payos' FOR UPDATE");
                $currentSt->execute([$orderId]);
                $current = $currentSt->fetch();
                if ($current && $current['status'] !== 'cancelled' && $current['payment_status'] !== 'paid'
                    && (string)$current['payos_payment_link_id'] === $linkId
                    && (int)$current['total'] === (int)$data['amount']
                    && (int)$current['total'] === (int)$data['amountPaid']) {
                    $pdo->prepare("UPDATE orders SET payment_status = 'paid', payos_paid_at = UTC_TIMESTAMP() WHERE id = ? AND payos_payment_link_id = ? AND status <> 'cancelled' AND payment_status <> 'paid'")
                        ->execute([$orderId, $linkId]);
                }
                $freshSt = $pdo->prepare("SELECT payment_status, status FROM orders WHERE id = ? AND payment_method = 'payos'");
                $freshSt->execute([$orderId]);
                $fresh = $freshSt->fetch();
                if ($fresh && $fresh['payment_status'] === 'paid' && $fresh['status'] !== 'cancelled') {
                    sync_order_rank($pdo, $orderId);
                }
                $pdo->commit();
                return (string)($fresh['payment_status'] ?? 'unpaid');
            } catch (Throwable $e) {
                if ($pdo->inTransaction()) $pdo->rollBack();
                throw $e;
            }
        }
    } catch (Throwable $e) {
        error_log('FishShop PayOS status check failed (' . get_class($e) . ').');
    }
    // Even on a timeout or unmatched response, report the persisted current value.
    $st->execute([$orderId]);
    $fresh = $st->fetch();
    return (string)($fresh['payment_status'] ?? 'unpaid');
}
function payos_valid_signature(array $data, string $signature, string $key): bool {
    if ($signature === '') return false;
    ksort($data);
    $parts = [];
    foreach ($data as $name => $value) {
        if ($value === null || $value === 'undefined' || $value === 'null') $value = '';
        elseif (is_array($value)) {
            foreach ($value as &$item) if (is_array($item)) ksort($item);
            unset($item);
            $value = json_encode($value, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        } elseif (is_bool($value)) $value = $value ? '1' : '';
        $parts[] = $name . '=' . $value;
    }
    return hash_equals(hash_hmac('sha256', implode('&', $parts), $key), strtolower($signature));
}

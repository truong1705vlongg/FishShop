<?php
require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/payos.php';
require_once __DIR__ . '/../includes/location.php';
require_once __DIR__ . '/../includes/vouchers.php';
$user = requireLogin();
requirePost('checkout.php');

$address = trim(post_string('shipping_address'));
$phone   = trim(post_string('phone'));
$paymentMethod = post_string('payment_method');
if (!in_array($paymentMethod, ['cash', 'bank_transfer', 'payos'], true)) respond(false, 'Vui lòng chọn phương thức thanh toán.', 'checkout.php');
if (mb_strlen($address) < 5 || mb_strlen($address) > 255) respond(false, 'Vui lòng nhập địa chỉ giao hàng (5-255 ký tự).', 'checkout.php');
if (!preg_match('/^[0-9]{9,11}$/', $phone)) respond(false, 'Số điện thoại gồm 9-11 chữ số.', 'checkout.php');
try {
    $shippingLocation = shipping_location_from_values($_POST['shipping_latitude'] ?? null, $_POST['shipping_longitude'] ?? null);
} catch (DomainException $ex) {
    respond(false, $ex->getMessage(), 'checkout.php');
}

$pdo = db();
try {
    $hasVoucherColumns = voucher_schema_ready($pdo);
    $hasLocationColumns = shipping_location_schema_ready($pdo);
    if ($shippingLocation !== null && !$hasLocationColumns) {
        respond(false, 'Chưa lưu được điểm giao hàng lúc này. Vui lòng bỏ ghim và nhập đầy đủ địa chỉ để đặt hàng.', 'checkout.php');
    }
    $pdo->beginTransaction();

    // Serialize checkout for the same account across sessions/devices.
    $cartSt = $pdo->prepare('SELECT id FROM cart WHERE user_id = ? FOR UPDATE');
    $cartSt->execute([(int)$user['id']]);
    $cartId = $cartSt->fetchColumn();
    if (!$cartId) { $pdo->rollBack(); respond(false, 'Giỏ hàng đang trống.', 'cart.php'); }

    $st = $pdo->prepare('SELECT product_id, quantity FROM cart_items WHERE cart_id = ? ORDER BY id FOR UPDATE');
    $st->execute([$cartId]);
    $items = $st->fetchAll();
    if (!$items) { $pdo->rollBack(); respond(false, 'Giỏ hàng đang trống.', 'cart.php'); }

    // Đọc giá + tồn kho HIỆN TẠI từ database (khóa dòng), tính tổng ở PHP
    $total = 0;
    $lines = [];
    $sel = $pdo->prepare("SELECT p.id, p.name, p.price, p.stock, p.status, c.status AS cat_status
                          FROM products p JOIN categories c ON c.id = p.category_id WHERE p.id = ? FOR UPDATE");
    foreach ($items as $it) {
        $sel->execute([(int)$it['product_id']]);
        $p = $sel->fetch();
        $q = (int)$it['quantity'];
        if (!$p || $p['status'] !== 'active' || $p['cat_status'] !== 'active') {
            $pdo->rollBack(); respond(false, 'Có sản phẩm đã ngừng bán. Vui lòng kiểm tra lại giỏ hàng.', 'cart.php');
        }
        if ($q < 1 || $q > (int)$p['stock']) {
            $pdo->rollBack(); respond(false, '“' . $p['name'] . '” chỉ còn ' . (int)$p['stock'] . ' sản phẩm. Vui lòng điều chỉnh giỏ hàng.', 'cart.php');
        }
        $lines[] = ['id' => (int)$p['id'], 'qty' => $q, 'price' => $p['price']];
        $total += $q * (float)$p['price'];
    }

    $subtotal = (int)$total;
    $selectedCode = isset($_SESSION['checkout_voucher']) && is_string($_SESSION['checkout_voucher']) ? $_SESSION['checkout_voucher'] : '';
    $voucher = voucher_quote($pdo, $selectedCode, (int)$user['id'], $subtotal, true);
    $total = $voucher['total'];
    if ($paymentMethod === 'payos' && ($total < 2000 || $total > 500000000)) {
        throw new DomainException('Chuyển khoản QR áp dụng cho số tiền từ 2.000 đ đến 500.000.000 đ. Vui lòng chọn tiền mặt hoặc thay đổi giỏ hàng/mã giảm giá.');
    }

    $orderSql = "INSERT INTO orders (user_id, total, shipping_address, phone, status, payment_status, payment_method";
    $orderArgs = [(int)$user['id'], $total, $address, $phone, $paymentMethod];
    if ($hasLocationColumns) {
        $orderSql .= ', shipping_latitude, shipping_longitude';
        $orderArgs[] = $shippingLocation['latitude'] ?? null;
        $orderArgs[] = $shippingLocation['longitude'] ?? null;
    }
    if ($hasVoucherColumns) {
        $orderSql .= ', subtotal, discount_amount, voucher_code';
        $orderArgs[] = $subtotal;
        $orderArgs[] = $voucher['discount'];
        $orderArgs[] = $voucher['code'] !== '' ? $voucher['code'] : null;
    }
    $orderSql .= ") VALUES (?,?,?,?, 'pending', 'unpaid', ?" . ($hasLocationColumns ? ',?,?' : '') . ($hasVoucherColumns ? ',?,?,?' : '') . ')';
    $pdo->prepare($orderSql)->execute($orderArgs);
    $orderId = (int)$pdo->lastInsertId();

    if ($voucher['voucher_id'] !== null) {
        $pdo->prepare('INSERT INTO voucher_usages (voucher_id, user_id, order_id, discount_amount) VALUES (?,?,?,?)')
            ->execute([$voucher['voucher_id'], (int)$user['id'], $orderId, $voucher['discount']]);
    }

    $ins = $pdo->prepare('INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?,?,?,?)');
    $dec = $pdo->prepare('UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?');
    foreach ($lines as $l) {
        $ins->execute([$orderId, $l['id'], $l['qty'], $l['price']]);   // lưu giá tại thời điểm mua
        $dec->execute([$l['qty'], $l['id'], $l['qty']]);
        if ($dec->rowCount() !== 1) throw new RuntimeException('Tồn kho không đủ');
    }
    $pdo->prepare('DELETE FROM cart_items WHERE cart_id = ?')->execute([$cartId]);   // chỉ xóa giỏ sau khi đơn đã tạo
    $pdo->commit();
    unset($_SESSION['checkout_voucher'], $_SESSION['checkout_draft']);
} catch (DomainException $ex) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    respond(false, $ex->getMessage(), 'checkout.php');
} catch (Throwable $ex) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    error_log('FishShop place order failed (' . get_class($ex) . ', code ' . (string)$ex->getCode() . ').');
    respond(false, 'Đặt hàng thất bại, giỏ hàng của bạn vẫn được giữ nguyên. Vui lòng thử lại.', 'checkout.php');
}
// Lưu địa chỉ/số điện thoại để lần sau tự điền sẵn
try {
    $pdo->prepare('UPDATE users SET address = ?, phone = ? WHERE id = ?')->execute([$address, $phone, (int)$user['id']]);
} catch (Throwable $ex) {
    error_log('FishShop order saved; could not remember profile delivery details.');
}
flash('success', 'Đã tạo đơn hàng #' . $orderId . '.');
if ($paymentMethod === 'payos') {
    try {
        payos_create_order_link($orderId);
    } catch (Throwable $ex) {
        error_log('FishShop PayOS checkout after order failed (' . get_class($ex) . ', code ' . (string)$ex->getCode() . ').');
        flash('error', 'Đơn đã được tạo. Chưa mở được mã QR chuyển khoản; vào đơn hàng và bấm “Mở mã QR chuyển khoản” để thử lại.');
    }
}
redirect('payment.php?id=' . $orderId);

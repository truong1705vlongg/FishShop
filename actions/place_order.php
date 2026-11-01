<?php
require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/payos.php';
require_once __DIR__ . '/../includes/location.php';
$user = requireLogin();
requirePost('checkout.php');

$address = trim($_POST['shipping_address'] ?? '');
$phone   = trim($_POST['phone'] ?? '');
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
    $hasLocationColumns = shipping_location_schema_ready($pdo);
    if ($shippingLocation !== null && !$hasLocationColumns) {
        respond(false, 'Chưa lưu được điểm giao hàng lúc này. Vui lòng bỏ ghim và nhập đầy đủ địa chỉ để đặt hàng.', 'checkout.php');
    }
    $pdo->beginTransaction();

    $cartId = get_cart_id((int)$user['id'], false);
    if (!$cartId) { $pdo->rollBack(); respond(false, 'Giỏ hàng đang trống.', 'cart.php'); }

    $st = $pdo->prepare('SELECT product_id, quantity FROM cart_items WHERE cart_id = ? ORDER BY id');
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

    $orderSql = "INSERT INTO orders (user_id, total, shipping_address, phone, status, payment_status, payment_method";
    $orderArgs = [(int)$user['id'], $total, $address, $phone, $paymentMethod];
    if ($hasLocationColumns) {
        $orderSql .= ', shipping_latitude, shipping_longitude';
        $orderArgs[] = $shippingLocation['latitude'] ?? null;
        $orderArgs[] = $shippingLocation['longitude'] ?? null;
    }
    $orderSql .= ") VALUES (?,?,?,?, 'pending', 'unpaid', ?" . ($hasLocationColumns ? ',?,?' : '') . ')';
    $pdo->prepare($orderSql)->execute($orderArgs);
    $orderId = (int)$pdo->lastInsertId();

    $ins = $pdo->prepare('INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?,?,?,?)');
    $dec = $pdo->prepare('UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?');
    foreach ($lines as $l) {
        $ins->execute([$orderId, $l['id'], $l['qty'], $l['price']]);   // lưu giá tại thời điểm mua
        $dec->execute([$l['qty'], $l['id'], $l['qty']]);
        if ($dec->rowCount() !== 1) throw new RuntimeException('Tồn kho không đủ');
    }
    $pdo->prepare('DELETE FROM cart_items WHERE cart_id = ?')->execute([$cartId]);   // chỉ xóa giỏ sau khi đơn đã tạo
    $pdo->commit();
} catch (Throwable $ex) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    error_log('FishShop place order failed (' . get_class($ex) . ', code ' . (string)$ex->getCode() . ').');
    respond(false, 'Đặt hàng thất bại, giỏ hàng của bạn vẫn được giữ nguyên. Vui lòng thử lại.', 'checkout.php');
}
// Lưu địa chỉ/số điện thoại để lần sau tự điền sẵn
$pdo->prepare('UPDATE users SET address = ?, phone = ? WHERE id = ?')->execute([$address, $phone, (int)$user['id']]);
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

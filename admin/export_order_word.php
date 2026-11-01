<?php
require_once __DIR__ . '/bootstrap.php';
requireAdmin();

$orderId = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]);
if (!$orderId) {
    http_response_code(400);
    exit('Mã đơn hàng không hợp lệ.');
}

$st = db()->prepare(
    'SELECT o.*, u.username, u.fullname FROM orders o JOIN users u ON u.id = o.user_id WHERE o.id = ?'
);
$st->execute([$orderId]);
$order = $st->fetch();
if (!$order) {
    http_response_code(404);
    exit('Không tìm thấy đơn hàng.');
}

$st = db()->prepare(
    'SELECT oi.quantity, oi.price, p.name FROM order_items oi JOIN products p ON p.id = oi.product_id WHERE oi.order_id = ? ORDER BY oi.id'
);
$st->execute([$orderId]);
$items = $st->fetchAll();

$orderStatus = ORDER_STATUS[$order['status']] ?? (string)$order['status'];
$paymentStatus = PAYMENT_STATUS[$order['payment_status']] ?? (string)$order['payment_status'];
$createdAt = date('d/m/Y H:i', strtotime((string)$order['created_at']));
$filename = 'FishShop-don-hang-' . (int)$order['id'] . '.doc';

header('Content-Type: application/msword; charset=UTF-8');
header('Content-Disposition: attachment; filename="' . $filename . '"');
header('Cache-Control: private, max-age=0, must-revalidate');
header('Pragma: public');
?>
<!DOCTYPE html>
<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" lang="vi">
<head>
<meta charset="UTF-8">
<title>Đơn hàng #<?= (int)$order['id'] ?> | Fish Shop</title>
<!--[if gte mso 9]><xml><w:WordDocument><w:View>Print</w:View><w:Zoom>100</w:Zoom></w:WordDocument></xml><![endif]-->
<style>
@page { size: A4; margin: 1.8cm; }
body { font-family: Arial, sans-serif; color: #17283a; font-size: 11pt; }
h1 { color: #0f766e; font-size: 22pt; margin: 0 0 5pt; }
h2 { color: #17344a; font-size: 13pt; margin: 0 0 9pt; }
p { margin: 3pt 0; }
.muted { color: #60758a; }
.top { border-bottom: 2px solid #39cbb1; padding-bottom: 12pt; margin-bottom: 16pt; }
.meta, .items { width: 100%; border-collapse: collapse; }
.meta td { width: 50%; vertical-align: top; padding: 8pt; border: 1px solid #d5e0e8; }
.items { margin-top: 16pt; }
.items th { color: #fff; background: #17344a; text-align: left; }
.items th, .items td { border: 1px solid #ccd8e2; padding: 8pt; }
.right { text-align: right; }
.total { font-weight: bold; color: #0f766e; font-size: 14pt; }
</style>
</head>
<body>
<div class="top">
  <p class="muted">FISH SHOP · THẾ GIỚI CÁ CẢNH</p>
  <h1>Đơn hàng #<?= (int)$order['id'] ?></h1>
  <p class="muted">Ngày đặt: <?= e($createdAt) ?></p>
</div>
<table class="meta">
  <tr>
    <td>
      <h2>Khách hàng</h2>
      <p><strong>Tài khoản:</strong> <?= e($order['username']) ?></p>
      <p><strong>Họ tên:</strong> <?= e($order['fullname']) ?></p>
      <p><strong>Điện thoại:</strong> <?= e($order['phone']) ?></p>
      <p><strong>Giao đến:</strong> <?= nl2br(e($order['shipping_address'])) ?></p>
    </td>
    <td>
      <h2>Thông tin đơn</h2>
      <p><strong>Mã đơn:</strong> #<?= (int)$order['id'] ?></p>
      <p><strong>Trạng thái đơn:</strong> <?= e($orderStatus) ?></p>
      <p><strong>Trạng thái thanh toán:</strong> <?= e($paymentStatus) ?></p>
      <p><strong>Tổng tiền:</strong> <span class="total"><?= e(money($order['total'])) ?></span></p>
    </td>
  </tr>
</table>
<h2 style="margin-top:18pt">Sản phẩm</h2>
<table class="items">
  <thead><tr><th>Sản phẩm</th><th class="right">Đơn giá</th><th class="right">Số lượng</th><th class="right">Thành tiền</th></tr></thead>
  <tbody>
  <?php foreach ($items as $item): ?>
    <tr>
      <td><?= e($item['name']) ?></td>
      <td class="right"><?= e(money($item['price'])) ?></td>
      <td class="right"><?= (int)$item['quantity'] ?></td>
      <td class="right"><?= e(money((float)$item['price'] * (int)$item['quantity'])) ?></td>
    </tr>
  <?php endforeach; ?>
  <tr><td colspan="3" class="right"><strong>Tổng cộng</strong></td><td class="right total"><?= e(money($order['total'])) ?></td></tr>
  </tbody>
</table>
</body>
</html>

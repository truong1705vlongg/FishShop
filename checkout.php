<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/maps.php';
$user  = requireLogin();
$lines = cart_lines((int)$user['id']);
if (!$lines) { flash('error', 'Giỏ hàng đang trống.'); redirect('cart.php'); }

$total = 0;
foreach ($lines as $l) {
    if ($l['status'] !== 'active' || (int)$l['stock'] < (int)$l['quantity'] || (int)$l['quantity'] < 1) {
        flash('error', 'Giỏ hàng có sản phẩm không đủ hàng hoặc đã ngừng bán. Vui lòng kiểm tra lại.');
        redirect('cart.php');
    }
    $total += (int)$l['quantity'] * (float)$l['price'];
}

$pageTitle = 'Xác nhận mua hàng';
$mapConfig = fishshop_maps_config();
$mapCenter = fishshop_store_point($mapConfig);
include __DIR__ . '/includes/header.php';
?>
<p class="crumb"><a href="<?= url('index.php') ?>">Trang chủ</a> / <a href="<?= url('cart.php') ?>">Giỏ hàng</a> / Xác nhận mua hàng</p>
<h1 style="font-size:28px">Xác nhận mua hàng</h1>
<div class="cart">
  <section class="card">
    <h2>Thông tin nhận hàng</h2>
    <form action="<?= url('actions/place_order.php') ?>" method="post" class="js-validate" novalidate>
      <?= csrf_field() ?>
      <div class="field"><label for="phone">Số điện thoại nhận hàng</label>
        <input id="phone" name="phone" type="text" inputmode="numeric" data-rule="phone" value="<?= e($user['phone']) ?>" required></div>
      <div class="field"><label for="shipping_address">Địa chỉ giao hàng</label>
        <textarea id="shipping_address" name="shipping_address" data-rule="address" required><?= e($user['address']) ?></textarea>
        <small>Kiểm tra kỹ địa chỉ và số điện thoại trước khi đặt.</small></div>
      <section class="delivery-location" data-map-widget="delivery"
          data-latitude="<?= e($mapCenter['latitude'] ?? '16.0') ?>"
          data-longitude="<?= e($mapCenter['longitude'] ?? '107.0') ?>"
          data-zoom="<?= $mapCenter ? '14' : '5' ?>" aria-labelledby="delivery-location-title">
        <div class="map-section-heading"><h3 id="delivery-location-title">Điểm giao hàng trên bản đồ</h3><span>Tùy chọn</span></div>
        <p class="map-hint">Chạm lên bản đồ hoặc kéo ghim đến nơi nhận hàng. Nhớ nhập đủ số nhà, tên đường ở phía trên.</p>
        <input type="hidden" name="shipping_latitude" id="shipping_latitude" value="">
        <input type="hidden" name="shipping_longitude" id="shipping_longitude" value="">
        <div class="fishshop-map delivery-map" data-map-canvas role="region" aria-label="Bản đồ chọn điểm giao hàng" tabindex="0"></div>
        <div class="map-actions">
          <button class="btn ghost sm" type="button" data-map-locate>Vị trí của tôi</button>
          <button class="btn ghost sm" type="button" data-map-center>Ghim tại tâm bản đồ</button>
          <button class="map-clear" type="button" data-map-clear disabled>Bỏ ghim</button>
        </div>
        <p class="map-selection" data-map-status role="status" aria-live="polite">Chưa chọn điểm giao hàng.</p>
        <p class="map-error" data-map-error role="status" hidden></p>
        <a class="map-selected-link" data-map-selected-link target="_blank" rel="noopener noreferrer" hidden>Xem điểm đã chọn</a>
        <noscript><p class="map-hint">Bật JavaScript để chọn điểm trên bản đồ. Bạn vẫn có thể đặt hàng bằng địa chỉ đã nhập.</p></noscript>
      </section>
      <fieldset class="field" style="border:0;padding:0;margin:0 0 16px">
        <legend style="font-size:13px;font-weight:600;margin-bottom:8px">Phương thức thanh toán</legend>
        <div class="payment-options">
          <label class="payment-option">
            <input type="radio" name="payment_method" value="cash" required checked>
            <span class="payment-option-copy"><b>Tiền mặt khi nhận hàng</b><small>Thanh toán trực tiếp cho nhân viên giao hàng.</small></span>
          </label>
          <label class="payment-option">
            <input type="radio" name="payment_method" value="payos" required>
            <span class="payment-option-copy"><b>Chuyển khoản ngân hàng</b><small>Quét mã QR; số tiền và nội dung đơn hàng sẽ được điền sẵn, hệ thống tự xác nhận.</small></span>
            <span class="payment-badge">QR</span>
          </label>
        </div>
      </fieldset>
      <button class="btn" type="submit">Đặt hàng</button>
      <a class="btn ghost" href="<?= url('cart.php') ?>">Quay lại giỏ hàng</a>
    </form>
  </section>
  <aside class="order-summary">
    <h2>Đơn hàng (<?= count($lines) ?> sản phẩm)</h2>
    <?php foreach ($lines as $l): ?>
      <div class="sum"><span><?= e($l['name']) ?> × <?= (int)$l['quantity'] ?></span><span><?= money((int)$l['quantity'] * (float)$l['price']) ?></span></div>
    <?php endforeach; ?>
    <div class="sum t"><span>Tổng cộng</span><span><?= money($total) ?></span></div>
    <p class="hint">Tổng tiền cuối cùng do máy chủ tính lại từ giá hiện tại khi bạn đặt hàng.</p>
  </aside>
</div>
<?php include __DIR__ . '/includes/footer.php'; ?>

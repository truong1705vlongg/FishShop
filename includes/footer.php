</main>
<?php
require_once __DIR__ . '/maps.php';
$footerMapConfig = fishshop_maps_config();
$storePoint = fishshop_store_point($footerMapConfig);
?>
<footer class="footer home-footer" id="ho-tro">
  <?php if (empty($minimal) && $storePoint !== null): ?>
  <section class="wrap store-location" data-map-widget="store"
      data-latitude="<?= e($storePoint['latitude']) ?>" data-longitude="<?= e($storePoint['longitude']) ?>"
      data-label="<?= e($footerMapConfig['store_location_name']) ?>" data-zoom="16" aria-labelledby="store-map-title">
    <div class="store-location-copy">
      <p class="map-eyebrow">TÌM ĐẾN CỬA HÀNG</p>
      <h2 id="store-map-title">Ghé thăm Fish Shop</h2>
      <p class="store-location-name"><?= e($footerMapConfig['store_location_name']) ?></p>
      <p class="store-location-address"><?= e($footerMapConfig['store_address']) ?></p>
      <a class="btn ghost" href="<?= e(fishshop_store_directions_url($footerMapConfig)) ?>" target="_blank" rel="noopener noreferrer">Chỉ đường đến cửa hàng</a>
    </div>
    <div class="store-map-wrap">
      <div class="fishshop-map store-map" data-map-canvas role="region" aria-label="Bản đồ vị trí cửa hàng" tabindex="0"></div>
      <p class="map-error" data-map-error role="status" hidden></p>
      <noscript><p class="map-hint">Dùng nút chỉ đường để mở vị trí trong Google Maps.</p></noscript>
    </div>
  </section>
  <?php endif; ?>
  <div class="wrap footer-grid">
    <div class="footer-brand"><a class="logo" href="<?= url('index.php') ?>"><img class="brand-avatar" src="<?= url('assets/images/fish-shop-logo.jpg') ?>" alt="" width="44" height="44">Fish Shop</a><p>Một góc thiên nhiên. Một chút bình yên.<br>Khám phá những sắc màu của thế giới cá cảnh.</p></div>
    <nav aria-label="Cửa hàng"><h3>CỬA HÀNG</h3><a href="<?= url('index.php') ?>">Trang chủ</a><a href="<?= url('index.php#san-pham') ?>">Danh sách sản phẩm</a><a href="<?= url('cart.php') ?>">Giỏ hàng</a></nav>
    <nav aria-label="Tài khoản"><h3>TÀI KHOẢN</h3><a href="<?= url('profile.php') ?>">Thông tin cá nhân</a><a href="<?= url('purchase_history.php') ?>">Đơn của tôi</a><a href="<?= url('forgot_password.php') ?>">Khôi phục mật khẩu</a></nav>
    <div><h3>HỖ TRỢ KHÁCH HÀNG</h3><p>Theo dõi đơn mua và thông tin thanh toán trong mục Đơn của tôi.</p><?php if (ADMIN_CONTACT_PHONE !== ''): ?><p>Điện thoại: <?= e(ADMIN_CONTACT_PHONE) ?></p><?php endif; ?><?php if (ADMIN_CONTACT_EMAIL !== ''): ?><p>Email: <?= e(ADMIN_CONTACT_EMAIL) ?></p><?php endif; ?></div>
  </div>
</footer>
<script src="<?= url('assets/js/main.js') ?>"></script>
<script type="application/json" id="fishshop-map-config"><?= json_encode(['tileUrl' => $footerMapConfig['tile_url']], JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT) ?></script>
<script src="<?= url('assets/js/maps.js') ?>?v=<?= filemtime(__DIR__ . '/../assets/js/maps.js') ?>" defer></script>
</body>
</html>

<?php
$firebaseWebConfig = require __DIR__ . '/../config/firebase.php';
$firebaseWebConfigured = true;
foreach (['apiKey', 'authDomain', 'projectId'] as $firebaseField) {
    if (!is_string($firebaseWebConfig[$firebaseField] ?? null) || trim($firebaseWebConfig[$firebaseField]) === '') $firebaseWebConfigured = false;
}
?>
<p id="firebase-status" class="hint" role="status" aria-live="polite"><?= $firebaseWebConfigured ? 'Đang chuẩn bị đăng nhập Google…' : 'Đăng nhập Google chưa được cấu hình trên máy chủ. Bạn có thể dùng mật khẩu.' ?></p>
<button id="firebase-retry" class="btn ghost sm hidden" type="button" hidden>Tải lại trang để thử Google</button>
<noscript><p class="alert err">Vui lòng bật JavaScript để đăng nhập Google.</p></noscript>
<script type="application/json" id="firebase-config"><?= json_encode($firebaseWebConfig, JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT) ?></script>
<script src="<?= url('assets/js/firebase-login.js') ?>?v=<?= filemtime(__DIR__ . '/../assets/js/firebase-login.js') ?>" defer></script>

<?php
// Điền thông tin OAuth Web application tại đây hoặc dùng biến môi trường.
return [
    'client_id' => getenv('FISHSHOP_GOOGLE_CLIENT_ID') ?: '',
    'client_secret' => getenv('FISHSHOP_GOOGLE_CLIENT_SECRET') ?: '',
    'redirect_uri' => getenv('FISHSHOP_GOOGLE_REDIRECT_URI') ?: 'http://localhost/FishShop/google_callback.php',
];

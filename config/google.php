<?php
require_once __DIR__ . '/runtime.php';

// Optional direct OAuth flow. Current Google buttons use Firebase instead.
return [
    'client_id' => fishshop_setting('FISHSHOP_GOOGLE_CLIENT_ID'),
    'client_secret' => fishshop_setting('FISHSHOP_GOOGLE_CLIENT_SECRET'),
    'redirect_uri' => fishshop_setting('FISHSHOP_GOOGLE_REDIRECT_URI', 'http://localhost/FishShop/google_callback.php'),
];

<?php
require_once __DIR__ . '/runtime.php';

return [
    'client_id' => fishshop_setting('PAYOS_CLIENT_ID'),
    'api_key' => fishshop_setting('PAYOS_API_KEY'),
    'checksum_key' => fishshop_setting('PAYOS_CHECKSUM_KEY'),
    'base_url' => rtrim(fishshop_setting('FISHSHOP_PUBLIC_URL', 'http://localhost/FishShop'), '/'),
];

<?php
// Environment variables override machine-local credentials. Do not commit payos.local.php.
$local = __DIR__ . '/payos.local.php';
$saved = is_file($local) ? require $local : [];
$saved = is_array($saved) ? $saved : [];
return [
    'client_id' => getenv('PAYOS_CLIENT_ID') ?: ($saved['client_id'] ?? ''),
    'api_key' => getenv('PAYOS_API_KEY') ?: ($saved['api_key'] ?? ''),
    'checksum_key' => getenv('PAYOS_CHECKSUM_KEY') ?: ($saved['checksum_key'] ?? ''),
    'base_url' => rtrim(getenv('FISHSHOP_PUBLIC_URL') ?: 'http://localhost/FishShop', '/'),
];

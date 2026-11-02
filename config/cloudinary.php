<?php
require_once __DIR__ . '/runtime.php';

return [
    'cloud_name' => trim(fishshop_setting('CLOUDINARY_CLOUD_NAME')),
    'api_key' => trim(fishshop_setting('CLOUDINARY_API_KEY')),
    'api_secret' => trim(fishshop_setting('CLOUDINARY_API_SECRET')),
    'folder' => trim(fishshop_setting('CLOUDINARY_FOLDER', 'fishshop'), '/ '),
];

<?php
require_once __DIR__ . '/runtime.php';

// Public Firebase Web config is read from PHP settings. Never expose service-account keys here.
return [
    'apiKey' => fishshop_setting('FISHSHOP_FIREBASE_API_KEY'),
    'authDomain' => fishshop_setting('FISHSHOP_FIREBASE_AUTH_DOMAIN'),
    'projectId' => fishshop_setting('FISHSHOP_FIREBASE_PROJECT_ID'),
    'storageBucket' => fishshop_setting('FISHSHOP_FIREBASE_STORAGE_BUCKET'),
    'messagingSenderId' => fishshop_setting('FISHSHOP_FIREBASE_MESSAGING_SENDER_ID'),
    'appId' => fishshop_setting('FISHSHOP_FIREBASE_APP_ID'),
    'measurementId' => fishshop_setting('FISHSHOP_FIREBASE_MEASUREMENT_ID'),
];

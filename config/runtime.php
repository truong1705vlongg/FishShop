<?php
// This branch reads PHP arrays only. It never reads .env or process environment values.
function fishshop_setting(string $name, string $default = ''): string
{
    static $settings = null;
    if ($settings === null) {
        $settings = require __DIR__ . '/settings.php';
        if (!is_array($settings)) throw new RuntimeException('Invalid PHP settings configuration.');
        $localPath = __DIR__ . '/settings.local.php';
        if (is_file($localPath)) {
            $local = require $localPath;
            if (!is_array($local)) throw new RuntimeException('Invalid local PHP settings configuration.');
            $settings = array_replace($settings, $local);
        }
    }
    $value = $settings[$name] ?? $default;
    return is_scalar($value) ? (string)$value : $default;
}

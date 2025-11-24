<?php

return [
    'name' => env('APP_NAME', 'Users API'),
    'env' => env('APP_ENV', 'production'),
    'debug' => env('APP_DEBUG', false),
    'url' => env('APP_URL', 'http://localhost'),
    'timezone' => 'UTC',
    'locale' => 'en',
    'fallback_locale' => 'en',
    'key' => env('APP_KEY', 'base64:'.base64_encode('dummy-key-for-minimal-setup')),
    'cipher' => 'AES-256-CBC',
];


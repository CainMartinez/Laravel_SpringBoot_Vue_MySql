<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    |
    | Here you may configure your settings for cross-origin resource sharing
    | or "CORS". This determines what cross-origin operations may execute
    | in web browsers. You are free to adjust these settings as needed.
    |
    */

    'paths' => ['api/*', 'sanctum/csrf-cookie'], // Rutas que permitirán CORS

    'allowed_methods' => ['*'], // Métodos permitidos (GET, POST, etc.)

    'allowed_origins' => [
        'http://vue:8085', // Frontend Vue
        'http://react:8086', // Frontend React
    ],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'], // Headers permitidos

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => false, // Cambiar a true si usas autenticación basada en cookies
];

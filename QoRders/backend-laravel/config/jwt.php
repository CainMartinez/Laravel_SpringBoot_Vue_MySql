<?php

return [
    // Clave secreta para firmar los tokens (definida en .env)
    'secret' => env('JWT_SECRET'),

    // Configuración de claves (solo si usas algoritmos asimétricos como RS256)
    'keys' => [
        'public' => env('JWT_PUBLIC_KEY'),
        'private' => env('JWT_PRIVATE_KEY'),
        'passphrase' => env('JWT_PASSPHRASE'),
    ],

    // Tiempo de vida del token (en minutos)
    'ttl' => env('JWT_TTL', 60),

    // Tiempo para refrescar el token (en minutos)
    'refresh_ttl' => env('JWT_REFRESH_TTL', 20160), // 14 días por defecto

    // Algoritmo de hash para firmar el token
    'algo' => env('JWT_ALGO', 'HS256'),

    // Claims requeridos en el payload del token
    'required_claims' => [
        'iss', // Emisor
        'iat', // Emitido en
        'exp', // Expiración
        'nbf', // No antes de
        'sub', // Sujeto
        'jti', // ID único del token
    ],

    // Claims que se deben mantener al refrescar un token
    'persistent_claims' => [],

    // Activar protección contra tokens con IDs duplicados entre diferentes modelos
    'lock_subject' => true,

    // Tiempo de tolerancia para sincronización de relojes entre servidores (en segundos)
    'leeway' => env('JWT_LEEWAY', 0),

    // Activar o desactivar la lista negra de tokens
    'blacklist_enabled' => env('JWT_BLACKLIST_ENABLED', true),

    // Periodo de gracia para evitar errores en peticiones concurrentes (en segundos)
    'blacklist_grace_period' => env('JWT_BLACKLIST_GRACE_PERIOD', 0),

    // Mostrar excepciones de lista negra en los logs
    'show_black_list_exception' => env('JWT_SHOW_BLACKLIST_EXCEPTION', true),

    // Configuración de cookies
    'decrypt_cookies' => false,
    
    // Configuración de proveedores
    'providers' => [
        'jwt' => PHPOpenSourceSaver\JWTAuth\Providers\JWT\Lcobucci::class,
        'auth' => PHPOpenSourceSaver\JWTAuth\Providers\Auth\Illuminate::class,
        'storage' => PHPOpenSourceSaver\JWTAuth\Providers\Storage\Illuminate::class,
    ],
];

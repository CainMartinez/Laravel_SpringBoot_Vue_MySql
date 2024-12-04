<?php

return [

    'defaults' => [
        'guard' => 'api',
        'passwords' => 'users',
    ],

    'guards' => [
        // Guard genérico para JWT
        'api' => [
            'driver' => 'jwt',
            'provider' => 'dynamic', // Proveedor dinámico basado en el token
        ],
    ],

    'providers' => [
        // Proveedor dinámico para Waiter y Manager basado en el role
        'dynamic' => [
            'driver' => 'eloquent',
            'model' => null, // El modelo se determinará dinámicamente en el controlador/middleware
        ],
        'waiters' => [
            'driver' => 'eloquent',
            'model' => App\Models\Waiter::class,
        ],
        'managers' => [
            'driver' => 'eloquent',
            'model' => App\Models\Manager::class,
        ],
    ],

    'passwords' => [
        'users' => [
            'provider' => 'users',
            'table' => 'password_reset_tokens',
            'expire' => 60,
            'throttle' => 60,
        ],
    ],

    'password_timeout' => env('AUTH_PASSWORD_TIMEOUT', 10800),

];

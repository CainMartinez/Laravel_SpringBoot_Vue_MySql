<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Redis;
use App\Http\Controllers\NGOController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\RoomController;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\AuthController;
use App\Http\Middleware\IsWaiter;
use App\Http\Middleware\IsManager;
use App\Http\Controllers\DonationController;
use App\Http\Controllers\WaiterController;
use App\Http\Controllers\DashboardController;

// Rutas públicas (sin middleware)
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']); // Registro
    Route::post('/login', [AuthController::class, 'login']); // Login
});

// Rutas protegidas por middlewares específicos (IsWaiter, IsManager)
Route::group(['prefix' => 'auth'], function () {

    // Rutas para Waiter
    Route::middleware(['IsWaiter'])->group(function () {
        Route::post('/waiter/logout', [AuthController::class, 'logout']); // Logout para Waiter
        Route::post('/waiter/refresh', [AuthController::class, 'refresh']); // Refrescar token para Waiter
        Route::get('/waiter/me', [AuthController::class, 'me']); // Perfil del Waiter
        Route::put('/waiter/update', [AuthController::class, 'updateWaiter']); // Actualizar perfil del Waiter
    });

    // Rutas para Manager
    Route::middleware(['IsManager'])->group(function () {
        
        // Rutas del módulo Auth
        Route::post('/manager/logout', [AuthController::class, 'logout']); // Logout para Manager
        Route::post('/manager/refresh', [AuthController::class, 'refresh']); // Refrescar token para Manager
        Route::get('/manager/me', [AuthController::class, 'me']); // Perfil del Manager
        Route::put('/manager/update', [AuthController::class, 'updateManager']); // Actualizar perfil del Manager

        // Ruta para métricas generales del dashboard
        Route::get('/manager/dashboard-metrics', [DashboardController::class, 'getMetrics']);

        // CRUD para ONGs
        Route::get('/manager/ngos', [NGOController::class, 'index']);
        Route::get('/manager/ngos/{slug}', [NGOController::class, 'indexBySlug']);
        Route::post('/manager/ngos', [NGOController::class, 'store']);
        Route::put('/manager/ngos/{slug}', [NGOController::class, 'update']);
        Route::put('/manager/ngos/{slug}/enable', [NGOController::class, 'enable']);
        Route::put('/manager/ngos/{slug}/disable', [NGOController::class, 'disable']);

        // CRUD para Salas (Rooms)
        Route::get('/manager/rooms', [RoomController::class, 'index']);
        Route::get('/manager/rooms/{slug}', [RoomController::class, 'indexBySlug']);
        Route::post('/manager/rooms', [RoomController::class, 'store']);
        Route::put('/manager/rooms/{slug}', [RoomController::class, 'update']);
        Route::put('/manager/rooms/{slug}/enable', [RoomController::class, 'enable']);
        Route::put('/manager/rooms/{slug}/disable', [RoomController::class, 'disable']);

        // CRUD para Productos
        Route::get('/manager/products', [ProductController::class, 'index']);
        Route::get('/manager/products/{room_theme}/by-room', [ProductController::class, 'indexByRoom']);
        Route::get('/manager/products/{slug}', [ProductController::class, 'indexBySlug']);
        Route::post('/manager/products', [ProductController::class, 'store']);
        Route::put('/manager/products/{slug}', [ProductController::class, 'update']);
        Route::put('/manager/products/{slug}/enable', [ProductController::class, 'enable']);
        Route::put('/manager/products/{slug}/disable', [ProductController::class, 'disable']);

        // CRUD para Camareros (Waiters)
        Route::get('/manager/waiters', [WaiterController::class, 'index']);
        Route::get('/manager/waiters/{email}', [WaiterController::class, 'indexByEmail']);
        Route::post('/manager/waiters', [WaiterController::class, 'store']);
        Route::put('/manager/waiters/{email}', [WaiterController::class, 'update']);
        Route::put('/manager/waiters/{email}/enable', [WaiterController::class, 'enable']);
        Route::put('/manager/waiters/{email}/disable', [WaiterController::class, 'disable']);
    });
});

// Ruta para crear una donación
Route::post('/donations', [DonationController::class, 'store']);
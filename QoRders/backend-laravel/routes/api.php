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

// Rutas públicas (sin middleware)
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']); // Registro
    Route::post('/login', [AuthController::class, 'login']); // Login
});


// Rutas protegidas por middlewares específicos
Route::group(['prefix' => 'auth'], function () {

    // Rutas para Waiter
    Route::middleware(['IsWaiter'])->group(function () {
        Route::post('/waiter/logout', [AuthController::class, 'logout']); // Logout para Waiter
        Route::post('/waiter/refresh', [AuthController::class, 'refresh']); // Refrescar token para Waiter
        Route::get('/waiter/me', [AuthController::class, 'me']); // Perfil del Waiter
    });

    // Rutas para Manager
    Route::middleware(['IsManager'])->group(function () {
        Route::post('/manager/logout', [AuthController::class, 'logout']); // Logout para Manager
        Route::post('/manager/refresh', [AuthController::class, 'refresh']); // Refrescar token para Manager
        Route::get('/manager/me', [AuthController::class, 'me']); // Perfil del Manager
    });
});

// Otros endpoints (NGOs, Products, Rooms, Bookings)
Route::prefix('ngos')->group(function () {
    Route::get('/', [NGOController::class, 'index']);
    Route::get('/{slug}', [NGOController::class, 'showBySlug']);
    Route::post('/', [NGOController::class, 'store']);
    Route::put('/{slug}', [NGOController::class, 'updateBySlug']);
    Route::put('/{slug}/unable', [NGOController::class, 'unableBySlug']); // Deshabilitar
    Route::put('/{slug}/enable', [NGOController::class, 'enableBySlug']); // Habilitar
});

Route::prefix('products')->group(function () {
    Route::get('/', [ProductController::class, 'index']);
    Route::get('/{slug}', [ProductController::class, 'showBySlug']);
    Route::post('/', [ProductController::class, 'store']);
    Route::put('/{slug}', [ProductController::class, 'updateBySlug']);
    Route::put('/{slug}/unable', [ProductController::class, 'unableBySlug']); // Deshabilitar
    Route::put('/{slug}/enable', [ProductController::class, 'enableBySlug']); // Habilitar
});

Route::prefix('rooms')->group(function () {
    Route::get('/', [RoomController::class, 'index']);
    Route::get('/{slug}', [RoomController::class, 'showBySlug']);
    Route::post('/', [RoomController::class, 'store']);
    Route::put('/{slug}', [RoomController::class, 'updateBySlug']);
    Route::put('/{slug}/unable', [RoomController::class, 'unableBySlug']); // Deshabilitar
    Route::put('/{slug}/enable', [RoomController::class, 'enableBySlug']); // Habilitar
    Route::get('/{slug}/products', [RoomController::class, 'getProductsByRoomSlug']);
});

Route::prefix('bookings')->group(function () {
    Route::get('/', [BookingController::class, 'index']); // Obtener todas las reservas
    Route::get('/{uuid}', [BookingController::class, 'show']); // Obtener una reserva por UUID
    Route::post('/', [BookingController::class, 'store']); // Crear una nueva reserva
    Route::put('/{uuid}', [BookingController::class, 'update']); // Actualizar una reserva por UUID
    Route::put('/{uuid}/unable', [BookingController::class, 'unable']); // Desactivar una reserva
});

Route::get('/redis-test-set', function () {
    // Guardar datos en Redis
    Redis::set('test_key', json_encode(['message' => 'Hello Redis!']));
    Redis::expire('test_key', 60); // Clave expira en 60 segundos
    return response()->json(['status' => 'Data stored successfully in Redis']);
});

Route::get('/redis-test-get', function () {
    // Recuperar datos desde Redis
    $data = Redis::get('test_key');
    if ($data) {
        return response()->json(['status' => 'Data retrieved from Redis', 'data' => json_decode($data, true)]);
    }
    return response()->json(['status' => 'No data found for key']);
});
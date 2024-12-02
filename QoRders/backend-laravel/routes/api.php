<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\NGOController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\RoomController;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\WaiterAuthController;
use App\Http\Controllers\ManagerAuthController;

// Rutas para los Waiters
Route::prefix('waiters')->group(function () {
    Route::post('/register', [WaiterAuthController::class, 'register']); // Registro de Waiter
    Route::post('/login', [WaiterAuthController::class, 'login']); // Login de Waiter

    Route::middleware(['auth.jwt'])->group(function () {
        Route::post('/logout', [WaiterAuthController::class, 'logout']); // Logout de Waiter
        Route::post('/refresh', [WaiterAuthController::class, 'refresh']); // Refrescar token de Waiter
        Route::get('/me', [WaiterAuthController::class, 'me']); // Obtener perfil del Waiter autenticado
    });
});

// Rutas para los Managers
Route::prefix('managers')->group(function () {
    Route::post('/register', [ManagerAuthController::class, 'register']); // Registro de Manager
    Route::post('/login', [ManagerAuthController::class, 'login']); // Login de Manager

    Route::middleware(['auth.jwt'])->group(function () {
        Route::post('/logout', [ManagerAuthController::class, 'logout']); // Logout de Manager
        Route::post('/refresh', [ManagerAuthController::class, 'refresh']); // Refrescar token de Manager
        Route::get('/me', [ManagerAuthController::class, 'me']); // Obtener perfil del Manager autenticado
    });
});

// Rutas para NGOs
Route::prefix('ngos')->group(function () {
    Route::get('/', [NGOController::class, 'index']);
    Route::get('/{slug}', [NGOController::class, 'showBySlug']);
    Route::post('/', [NGOController::class, 'store']);
    Route::put('/{slug}', [NGOController::class, 'updateBySlug']);
    Route::put('/{slug}/unable', [NGOController::class, 'unableBySlug']); // Deshabilitar
    Route::put('/{slug}/enable', [NGOController::class, 'enableBySlug']); // Habilitar
});

// Rutas para Products
Route::prefix('products')->group(function () {
    Route::get('/', [ProductController::class, 'index']);
    Route::get('/{slug}', [ProductController::class, 'showBySlug']);
    Route::post('/', [ProductController::class, 'store']);
    Route::put('/{slug}', [ProductController::class, 'updateBySlug']);
    Route::put('/{slug}/unable', [ProductController::class, 'unableBySlug']); // Deshabilitar
    Route::put('/{slug}/enable', [ProductController::class, 'enableBySlug']); // Habilitar
});

// Rutas para Rooms
Route::prefix('rooms')->group(function () {
    Route::get('/', [RoomController::class, 'index']);
    Route::get('/{slug}', [RoomController::class, 'showBySlug']);
    Route::post('/', [RoomController::class, 'store']);
    Route::put('/{slug}', [RoomController::class, 'updateBySlug']);
    Route::put('/{slug}/unable', [RoomController::class, 'unableBySlug']); // Deshabilitar
    Route::put('/{slug}/enable', [RoomController::class, 'enableBySlug']); // Habilitar
    Route::get('/{slug}/products', [RoomController::class, 'getProductsByRoomSlug']);
});

// Rutas para Bookings
Route::prefix('bookings')->group(function () {
    Route::get('/', [BookingController::class, 'index']); // Obtener todas las reservas
    Route::get('/{uuid}', [BookingController::class, 'show']); // Obtener una reserva por UUID
    Route::post('/', [BookingController::class, 'store']); // Crear una nueva reserva
    Route::put('/{uuid}', [BookingController::class, 'update']); // Actualizar una reserva por UUID
    Route::put('/{uuid}/unable', [BookingController::class, 'unable']); // Desactivar una reserva
});
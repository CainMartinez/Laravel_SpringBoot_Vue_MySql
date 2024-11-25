<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\NGOController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\RoomController;
use App\Http\Controllers\BookingController;

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

<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\NGOController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\RoomController;

Route::prefix('ngos')->group(function () {
    Route::get('/', [NGOController::class, 'index']); // Obtener todos los NGOs
    Route::get('/{slug}', [NGOController::class, 'showBySlug']); // Obtener un NGO por Slug
    Route::post('/', [NGOController::class, 'store']); // Crear un nuevo NGO
    Route::put('/{slug}', [NGOController::class, 'updateBySlug']); // Actualizar un NGO
    Route::delete('/{slug}', [NGOController::class, 'deleteBySlug']); // Eliminar un NGO
});

Route::prefix('products')->group(function () {
    Route::get('/', [ProductController::class, 'index']); // Obtener todos los productos
    Route::get('/{slug}', [ProductController::class, 'showBySlug']); // Obtener un producto por Slug
    Route::post('/', [ProductController::class, 'store']); // Crear un nuevo producto
    Route::put('/{slug}', [ProductController::class, 'updateBySlug']); // Actualizar un producto
    Route::delete('/{slug}', [ProductController::class, 'deleteBySlug']); // Eliminar un producto
});

Route::prefix('rooms')->group(function () {
    Route::get('/', [RoomController::class, 'index']); // Obtener todas las salas
    Route::get('/{slug}', [RoomController::class, 'showBySlug']); // Obtener una sala por Slug
    Route::post('/', [RoomController::class, 'store']); // Crear una nueva sala
    Route::put('/{slug}', [RoomController::class, 'updateBySlug']); // Actualizar una sala
    Route::delete('/{slug}', [RoomController::class, 'deleteBySlug']); // Eliminar una sala
    Route::get('/{slug}/products', [RoomController::class, 'getProductsByRoomSlug']); // Obtener todos los productos de una sala
});

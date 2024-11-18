<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\NGOController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\RoomController;

Route::prefix('ngos')->group(function () {
    Route::get('/', [NGOController::class, 'index']); // Obtener todos los NGOs
    Route::get('/{id}', [NGOController::class, 'show']); // Obtener un NGO por ID
    Route::post('/', [NGOController::class, 'store']); // Crear un nuevo NGO
    Route::put('/{id}', [NGOController::class, 'update']); // Actualizar un NGO
    Route::delete('/{id}', [NGOController::class, 'destroy']); // Eliminar un NGO
});

Route::prefix('products')->group(function () {
    Route::get('/', [ProductController::class, 'index']); // Obtener todos los productos
    Route::get('/{id}', [ProductController::class, 'show']); // Obtener un producto por ID
    Route::post('/', [ProductController::class, 'store']); // Crear un nuevo producto
    Route::put('/{id}', [ProductController::class, 'update']); // Actualizar un producto
    Route::delete('/{id}', [ProductController::class, 'destroy']); // Eliminar un producto
});

Route::prefix('rooms')->group(function () {
    Route::get('/', [RoomController::class, 'index']); // Obtener todas las salas
    Route::get('/{id}', [RoomController::class, 'show']); // Obtener una sala por ID
    Route::post('/', [RoomController::class, 'store']); // Crear una nueva sala
    Route::put('/{id}', [RoomController::class, 'update']); // Actualizar una sala
    Route::delete('/{id}', [RoomController::class, 'destroy']); // Eliminar una sala
});

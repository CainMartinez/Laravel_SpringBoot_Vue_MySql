<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration{
    /**
     * Run the migrations.
     */
    public function up(){
        Schema::create('rooms', function (Blueprint $table) {
            $table->id('room_id'); // Clave primaria
            $table->uuid('room_uuid'); // UUID
            $table->string('room_name', 100); // Nombre de la habitación
            $table->string('room_slug', 100); // Slug
            $table->text('description')->nullable(); // Descripción
            $table->string('theme', 100); // Tema
            $table->integer('max_capacity'); // Capacidad máxima
            $table->integer('total_bookings')->default(0); // Reservas totales
            $table->decimal('average_rating', 3, 2)->default(0.00); // Calificación promedio
            $table->text('image_url')->nullable(); // URL de imagen
            $table->boolean('is_active')->default(true); // Activo o no
            $table->integer('ngo_id'); // ID de la ONG
            $table->timestamps(); // created_at y updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(){
        Schema::dropIfExists('rooms');
    }
};

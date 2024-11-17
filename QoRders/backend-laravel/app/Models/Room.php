<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Room extends Model
{
    use HasFactory;

    // Nombre de la tabla (opcional si el nombre del modelo no coincide con la tabla)
    protected $table = 'rooms';

    // Clave primaria personalizada
    protected $primaryKey = 'room_id';

    // Campos que se pueden asignar en masa
    protected $fillable = [
        'room_uuid',
        'room_name',
        'room_slug',
        'description',
        'theme',
        'max_capacity',
        'total_bookings',
        'average_rating',
        'image_url',
        'is_active',
        'ngo_id',
    ];

    // Campos que deben tratarse como fechas
    protected $dates = ['created_at', 'updated_at'];

    // Desactivar timestamps si no se utilizan
    public $timestamps = true;
}
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    use HasFactory;

    // Tabla asociada al modelo
    protected $table = 'Booking';

    // Llave primaria
    protected $primaryKey = 'booking_uuid';

    // Deshabilitar incremento automático de la llave primaria
    public $incrementing = false;

    // Tipo de llave primaria
    protected $keyType = 'string';

    // Campos que se pueden asignar masivamente
    protected $fillable = [
        'booking_uuid',
        'customer_id',
        'room_shift_id',
        'guest_count',
        'status',
        'notes',
    ];

    // Fechas
    protected $dates = ['created_at', 'updated_at'];

    // Valores por defecto
    protected $attributes = [
        'status' => 'Pending',
    ];
}

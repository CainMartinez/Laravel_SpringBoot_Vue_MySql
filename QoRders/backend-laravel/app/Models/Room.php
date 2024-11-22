<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str; // Importar Str para usar slugify y UUID

class Room extends Model
{
    use HasFactory;

    // Nombre de la tabla
    protected $table = 'Room';

    // Clave primaria
    protected $primaryKey = 'room_id';

    // Indicar si la clave primaria es autoincremental
    public $incrementing = false;

    // Tipo de la clave primaria
    protected $keyType = 'int';

    // Indicar que se manejan timestamps automáticamente
    public $timestamps = true;

    // Columnas que se pueden llenar masivamente
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

    // Relación 1:1 con NGO
    public function ngo()
    {
        return $this->belongsTo(NGO::class, 'ngo_id', 'ngo_id');
    }

    // Generar UUID automáticamente al crear un registro
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($room) {
            if (empty($room->room_uuid)) {
                $room->room_uuid = (string) Str::uuid();
            }
        });
    }
}

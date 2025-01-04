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
    public $incrementing = true;

    // Tipo de la clave primaria
    protected $keyType = 'int';

    // Indicar que se manejan timestamps automáticamente
    public $timestamps = false;

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

    // Relación con Room_Shift
    public function roomShifts()
    {
        return $this->hasMany(RoomShift::class, 'room_id', 'room_id');
    }

    // Generar UUID automáticamente al crear un registro
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($room) {
            if (empty($room->room_uuid)) {
                $room->room_uuid = (string) Str::uuid();
            }

            if (!$room->theme) {
                $room->theme = NGO::where('ngo_id', $room->ngo_id)->value('country') ?? 'Desconocido';
            }
        });
        static::updating(function ($room) {
            if ($room->isDirty('ngo_id')) {
                $ngo = NGO::find($room->ngo_id);
                $room->theme = $ngo ? $ngo->country : $room->theme;
            }
        });
    }

    private static function generateSlug($name)
    {
        return Str::slug($name, '_') . '_' . mt_rand(100000, 999999);
    }

}

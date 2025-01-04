<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class RoomShift extends Model
{
     use HasFactory;

     // Nombre de la tabla
     protected $table = 'Room_Shift';

     // Clave primaria de la tabla
     protected $primaryKey = 'room_shift_id';

     // Indicar que no es autoincremental
     public $incrementing = true;

     // Tipo de la clave primaria
     protected $keyType = 'int';

     // Activar timestamps
     public $timestamps = true;

     // Columnas que se pueden llenar masivamente
     protected $fillable = [
          'room_shift_uuid',
          'room_id',
          'shift_id',
          'reserved_capacity',
          'total_revenue',
          'status',
          'is_active',
     ];

     // Relación con Room
     public function room()
     {
          return $this->belongsTo(Room::class, 'room_id', 'room_id');
     }

     // Relación con Shift
     public function shift()
     {
          return $this->belongsTo(Shift::class, 'shift_id', 'shift_id');
     }

     // Relación con Booking (1 a N)
     public function bookings()
     {
          return $this->hasMany(Booking::class, 'room_shift_id', 'room_shift_id');
     }

     // Scope para filtrar por estado
     public function scopeByStatus($query, $status)
     {
          $validStatuses = ['Active', 'Closed', 'Pending'];

          if (in_array($status, $validStatuses)) {
               return $query->where('status', $status);
          }
          return $query;
     }

     // Scope para filtrar solo room_shifts activos
     public function scopeActive($query)
     {
          return $query->where('is_active', 1);
     }

     // Generar UUID automáticamente al crear un registro
     protected static function boot()
     {
          parent::boot();

          static::creating(function ($roomShift) {
               if (empty($roomShift->room_shift_uuid)) {
                    $roomShift->room_shift_uuid = (string) Str::uuid();
               }
          });
     }
}

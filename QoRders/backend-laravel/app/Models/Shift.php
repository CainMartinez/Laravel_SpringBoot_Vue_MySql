<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Shift extends Model
{
     use HasFactory;

     // Nombre de la tabla
     protected $table = 'Shift';

     // Clave primaria de la tabla
     protected $primaryKey = 'shift_id';

     // Indicar si la clave primaria es autoincremental
     public $incrementing = true;

     // Tipo de la clave primaria
     protected $keyType = 'int';

     // Desactivar timestamps automáticos
     public $timestamps = false;

     // Columnas que se pueden llenar masivamente
     protected $fillable = [
          'shift_uuid',
          'shift_date',
          'shift_type',
          'total_revenue',
          'is_active',
     ];


     // Relación con Room_Shift
     public function roomShifts()
     {
          return $this->hasMany(RoomShift::class, 'shift_id', 'shift_id');
     }

     // Scope para filtrar turnos activos
     public function scopeActive($query)
     {
          return $query->where('is_active', 1);
     }

     // Scope para filtrar turnos inactivos
     public function scopeInactive($query)
     {
          return $query->where('is_active', 0);
     }

     // Scope para filtrar turnos por fecha específica
     public function scopeByDate($query, $date)
     {
          return $query->where('shift_date', $date);
     }

     // Scope para filtrar por tipo de turno (Lunch o Dinner)
     public function scopeByType($query, $type)
     {
          $validTypes = ['Lunch', 'Dinner'];
          
          if (in_array($type, $validTypes)) {
               return $query->where('shift_type', $type);
          }
          
          return $query->whereNull('shift_type'); // Devuelve resultados vacíos si el tipo no es válido
     }


     // Generar UUID automáticamente al crear un registro
     protected static function boot()
     {
          parent::boot();

          static::creating(function ($shift) {
               if (empty($shift->shift_uuid)) {
                    $shift->shift_uuid = (string) Str::uuid();
               }
          });
     }
}

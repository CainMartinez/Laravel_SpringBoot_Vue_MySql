<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use PHPOpenSourceSaver\JWTAuth\Contracts\JWTSubject;
use Illuminate\Support\Str;

class Waiter extends Authenticatable implements JWTSubject
{
     use HasFactory;

     // Nombre de la tabla asociada
     protected $table = 'Waiter';

     // Clave primaria de la tabla
     protected $primaryKey = 'waiter_id';

     // Indicar si la clave primaria es autoincremental
     public $incrementing = true;

     // Tipo de la clave primaria
     protected $keyType = 'int';

     // Timestamps automáticos
     public $timestamps = false;

     // Columnas que pueden ser llenadas masivamente
     protected $fillable = [
          'waiter_uuid',
          'room_id',
          'firstName',
          'lastName',
          'email',
          'password',
          'phone_number',
          'hire_date',
          'average_rating',
          'salary',
          'shift_disponibility',
          'is_active',
          'avatar_url',
          'bio'
     ];

     // Generación automática de UUID al crear un registro
     protected static function booted()
     {
          static::creating(function ($waiter) {
               if (empty($waiter->waiter_uuid)) {
                    $waiter->waiter_uuid = (string) Str::uuid();
               }
          });
     }

     // Relación con Room (N a 1): Un camarero pertenece a una sala
     public function room()
     {
          return $this->belongsTo(Room::class, 'room_id', 'room_id');
     }

     // Scope para filtrar solo camareros activos
     public function scopeActive($query)
     {
          return $query->where('is_active', 1);
     }

     // Scope para filtrar solo camareros inactivos
     public function scopeInactive($query)
     {
          return $query->where('is_active', 0);
     }

     // Scope para filtrar por disponibilidad de turno
     public function scopeByShift($query, $shift)
     {
          return $query->where('shift_disponibility', $shift);
     }

     // Métodos requeridos por la interfaz JWTSubject
     public function getJWTIdentifier()
     {
          return $this->email; // Identificador único: email
     }

     public function getJWTCustomClaims()
     {
          return ['role' => 'waiter']; // Reclamo personalizado para indicar el rol
     }
}

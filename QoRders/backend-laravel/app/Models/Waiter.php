<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use PHPOpenSourceSaver\JWTAuth\Contracts\JWTSubject;

class Waiter extends Authenticatable implements JWTSubject
{
     use HasFactory;

     // Nombre de la tabla asociada
     protected $table = 'Waiter';

     // Clave primaria de la tabla
     protected $primaryKey = 'waiter_id';

     // Indicar si la clave primaria es autoincremental
     public $incrementing = false;

     // Tipo de la clave primaria
     protected $keyType = 'int';

     // Timestamps automáticos
     public $timestamps = true;

     // Columnas que pueden ser llenadas masivamente
     protected $fillable = [
          'waiter_uuid',
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
          'bio',
          'room_id'
     ];

     // Métodos requeridos por la interfaz JWTSubject
     public function getJWTIdentifier()
     {
     return $this->email; // Identificador único: email
     }

     public function getJWTCustomClaims()
     {
          return ['role' => 'waiter']; // Reclamo personalizado para indicar el rol
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
}

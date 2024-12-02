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
          'first_name',
          'last_name',
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
     ];

     // Métodos requeridos por la interfaz JWTSubject
     public function getJWTIdentifier()
     {
          return $this->getKey(); // Identificador único del usuario (waiter_id)
     }

     public function getJWTCustomClaims()
     {
          return ['role' => 'waiter']; // Reclamo personalizado para indicar el rol
     }

     // Scope para filtrar solo camareros activos ($activeWaiters = Waiter::active()->get();)
     //(consulta SQL:SELECT * FROM Waiter WHERE is_active = 1;)
     public function scopeActive($query)
     {
          return $query->where('is_active', 1);
     }

     // Scope para filtrar solo camareros inactivos ($inactiveWaiters = Waiter::inactive()->get();)
     //(consulta SQL:SELECT * FROM Waiter WHERE is_active = 0;)
     public function scopeInactive($query)
     {
          return $query->where('is_active', 0);
     }

    // Puedes agregar relaciones aquí si es necesario en el futuro
}

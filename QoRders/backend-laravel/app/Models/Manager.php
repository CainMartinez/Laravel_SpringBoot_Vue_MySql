<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use PHPOpenSourceSaver\JWTAuth\Contracts\JWTSubject;

class Manager extends Authenticatable implements JWTSubject
{
     use HasFactory;

     // Nombre de la tabla asociada
     protected $table = 'Manager';

     // Clave primaria de la tabla
     protected $primaryKey = 'manager_id';

     // Indicar si la clave primaria es autoincremental
     public $incrementing = false;

     // Tipo de la clave primaria
     protected $keyType = 'int';

     // Timestamps automáticos
     public $timestamps = true;

     // Columnas que pueden ser llenadas masivamente
     protected $fillable = [
          'manager_uuid',
          'first_name',
          'last_name',
          'email',
          'password',
          'phone_number',
          'address',
          'salary',
          'is_active',
          'bio',
          'avatar_url',
     ];

     // Métodos requeridos por la interfaz JWTSubject
     public function getJWTIdentifier()
     {
          return $this->getKey(); // Identificador único del usuario (manager_id)
     }

     public function getJWTCustomClaims()
     {
          return ['role' => 'manager']; // Reclamo personalizado para indicar el rol
     }

    // Puedes agregar relaciones aquí si es necesario en el futuro
}

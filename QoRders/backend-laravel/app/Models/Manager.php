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
     public $incrementing = true;

     // Tipo de la clave primaria
     protected $keyType = 'int';

     // Timestamps automáticos
     public $timestamps = false;

     // Columnas que pueden ser llenadas masivamente
     protected $fillable = [
          'manager_uuid',
          'firstName',
          'lastName',
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
     return $this->email; // Identificador único: email
     }

     public function getJWTCustomClaims()
     {
          return ['role' => 'manager']; // Reclamo personalizado para indicar el rol
     }

}

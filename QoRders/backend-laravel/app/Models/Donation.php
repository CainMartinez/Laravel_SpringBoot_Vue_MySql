<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Donation extends Model
{
     // Tabla asociada al modelo
     protected $table = 'Donations';

     // Clave primaria de la tabla
     protected $primaryKey = 'donation_id';

     // Deshabilitar timestamps automáticos si no usas `updated_at`
     public $timestamps = false;

     // Campos asignables para el modelo
     protected $fillable = [
          'customer_username',
          'quantity',
          'ngo_slug',
     ];
}

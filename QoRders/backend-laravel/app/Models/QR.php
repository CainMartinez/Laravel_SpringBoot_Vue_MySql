<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class QR extends Model
{
     use HasFactory;

     // Nombre de la tabla
     protected $table = 'QR';

     // Clave primaria
     protected $primaryKey = 'id';

     // Indicar que es autoincremental
     public $incrementing = true;

     // Tipo de la clave primaria
     protected $keyType = 'int';

     // Timestamps automáticos
     public $timestamps = false;

     // Columnas que pueden ser llenadas masivamente
     protected $fillable = [
          'booking_id',
          'url',
          'status',
     ];

     // Relación 1:1 con Booking
     public function booking()
     {
          return $this->belongsTo(Booking::class, 'booking_id', 'booking_id');
     }

     // Scope para filtrar QR por estado (Generated, Printed, In_progress, Expired)
     public function scopeByStatus($query, $status)
     {
          $validStatuses = ['Generated', 'Printed', 'In_progress', 'Expired'];

          if (in_array($status, $validStatuses)) {
               return $query->where('status', $status);
          }
          return $query;
     }
}

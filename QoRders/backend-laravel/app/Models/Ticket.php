<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Ticket extends Model
{
     use HasFactory;

     // Nombre de la tabla
     protected $table = 'Tickets';

     // Clave primaria de la tabla
     protected $primaryKey = 'ticket_id';

     // Indicar que sí es autoincremental
     public $incrementing = true;

     // Tipo de la clave primaria
     protected $keyType = 'int';

     // Timestamps automáticos
     public $timestamps = false;

     // Columnas que se pueden llenar masivamente
     protected $fillable = [
          'ticket_uuid',
          'booking_id',
          'total_amount',
          'amount_to_pay',
          'donated_amount',
          'payment_status',
     ];

    // Relación 1:1 con Booking
     public function booking()
     {
          return $this->belongsTo(Booking::class, 'booking_id', 'booking_id');
     }

     // Relación 1:N inversa con Orders (a través de Booking)
     public function orders()
     {
          return $this->hasManyThrough(Order::class, Booking::class, 'booking_id', 'booking_id', 'booking_id', 'booking_id');
     }

     // Método para calcular el total_amount sumando todas las orders asociadas
     public function calculateTotalAmount()
     {
          $total = $this->orders()->sum('total_amount');

          // Actualizar el total_amount y guardar en la base de datos
          $this->update(['total_amount' => $total]);

          return $total;
     }
}

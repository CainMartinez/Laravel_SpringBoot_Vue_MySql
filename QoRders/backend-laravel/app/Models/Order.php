<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Order extends Model
{
     use HasFactory;

     // Nombre de la tabla
     protected $table = 'Orders';

     // Clave primaria de la tabla
     protected $primaryKey = 'order_id';

     // Indicar que es autoincremental
     public $incrementing = true;

     // Tipo de la clave primaria
     protected $keyType = 'int';

     // Timestamps automáticos
     public $timestamps = false;

     // Columnas que se pueden llenar masivamente
     protected $fillable = [
          'order_uuid',
          'booking_id',
          'is_active',
          'order_status',
          'payment_status',
          'total_amount',
          'notes',
     ];

     // Relación con Booking (N a 1)
     public function booking()
     {
          return $this->belongsTo(Booking::class, 'booking_id', 'booking_id');
     }

     //Relación con Order_Product (N a N)
     public function products()
     {
     return $this->belongsToMany(Product::class, 'Orders_Products', 'order_id', 'product_id')
                    ->withPivot(['quantity', 'is_delivered', 'created_at', 'updated_at']);
     }

     // Scope para filtrar órdenes activas
     public function scopeActive($query)
     {
          return $query->where('is_active', 1);
     }

     // Scope para filtrar órdenes inactivas
     public function scopeInactive($query)
     {
          return $query->where('is_active', 0);
     }

     // Scope para filtrar por estado de la orden
     public function scopeByOrderStatus($query, $status)
     {
          $validStatuses = ['Waiting', 'Assigned', 'Delivered'];
          if (in_array($status, $validStatuses)) {
               return $query->where('order_status', $status);
          }
          return $query;
     }

     // Scope para filtrar por estado de pago
     public function scopeByPaymentStatus($query, $status)
     {
          $validStatuses = ['Paid', 'Unpaid'];
          if (in_array($status, $validStatuses)) {
               return $query->where('payment_status', $status);
          }
          return $query;
     }

     public function markProductsAsDelivered()
     {
     // Acceder a los registros en Orders_Products asociados a esta orden
     return OrderProduct::where('order_id', $this->order_id)
                         ->update(['is_delivered' => 1]);
     }
}

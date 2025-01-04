<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderProduct extends Model
{
     use HasFactory;

     // Nombre de la tabla
     protected $table = 'Orders_Products';

     // Clave primaria
     protected $primaryKey = 'order_product_id';

     // La clave primaria es autoincremental
     public $incrementing = true;

     // Tipo de clave primaria
     protected $keyType = 'int';

     // Timestamps automáticos
     public $timestamps = true;

     // Columnas que se pueden llenar masivamente
     protected $fillable = [
          'order_id',
          'product_id',
          'quantity',
          'is_delivered',
     ];

     // Relación con el producto
     public function product()
     {
          return $this->belongsTo(Product::class, 'product_id', 'product_id');
     }

     // Relación con la orden
     public function order()
     {
          return $this->belongsTo(Order::class, 'order_id', 'order_id');
     }

     // Scope para filtrar productos entregados
     public function scopeDelivered($query)
     {
          return $query->where('is_delivered', 1);
     }

     // Scope para productos no entregados
     public function scopePending($query)
     {
          return $query->where('is_delivered', 0);
     }
}

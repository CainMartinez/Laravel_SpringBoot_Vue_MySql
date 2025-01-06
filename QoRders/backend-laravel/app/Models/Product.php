<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Product extends Model
{
    use HasFactory;

    // Nombre de la tabla
    protected $table = 'Products';

    // Clave primaria de la tabla
    protected $primaryKey = 'product_id';

    // Indicar si la clave primaria es autoincremental
    public $incrementing = true;

    // Tipo de la clave primaria
    protected $keyType = 'int';

    // Desactivar timestamps si Laravel no debe manejarlos automáticamente
    public $timestamps = false;

    // Columnas que se pueden llenar masivamente
    protected $fillable = [
        'product_uuid',
        'product_name',
        'product_slug',
        'description',
        'unit_price',
        'allergens',
        'stock',
        'image_url',
        'product_type',
        'origin',
        'is_active',
    ];

    protected static function booted()
    {
        static::creating(function ($product) {
            $product->product_uuid = (string) Str::uuid();
        });
    }

    public function ngo()
    {
        return $this->belongsTo(NGO::class, 'origin', 'country');
    }

    //Relación con Order_Product (N a N)
    public function orders()
    {
        return $this->belongsToMany(Order::class, 'Orders_Products', 'product_id', 'order_id')
                    ->withPivot(['quantity', 'is_delivered', 'created_at', 'updated_at']);
    }

    protected static function generateSlug($name)
    {
        return Str::slug($name, '_') . '_' . mt_rand(100000, 999999);
    }
}


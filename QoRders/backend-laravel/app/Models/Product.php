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
    public $incrementing = false;

    // Tipo de la clave primaria
    protected $keyType = 'int';

    // Desactivar timestamps si Laravel no debe manejarlos automáticamente
    public $timestamps = true;

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
}

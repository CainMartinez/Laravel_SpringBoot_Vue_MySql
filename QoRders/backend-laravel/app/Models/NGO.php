<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class NGO extends Model
{
    use HasFactory;

    // Nombre de la tabla (por defecto Laravel asume el plural 'ngos')
    protected $table = 'NGO';

    // Clave primaria de la tabla
    protected $primaryKey = 'ngo_id';

    // Indicar si la clave primaria es autoincremental
    public $incrementing = false;

    // Tipo de la clave primaria (int, string, etc.)
    protected $keyType = 'int';

    // Desactivar timestamps si Laravel no debe manejarlos automáticamente
    public $timestamps = true;

    // Columnas que se pueden llenar masivamente
    protected $fillable = [
        'ngo_uuid',
        'ngo_name',
        'ngo_slug',
        'description',
        'country',
        'email',
        'phone_number',
        'website_url',
        'logo_url',
        'image_url',
        'total_donations',
    ];

     // Relación 1:1 con Room
    public function room()
    {
        return $this->hasOne(Room::class, 'ngo_id', 'ngo_id');
    }
    // Relación 1:N con Product
    public function products()
    {
        return $this->hasMany(Product::class, 'origin', 'country');
    }
    public static function boot()
    {
        parent::boot();
        // Generar automáticamente el slug al crear un NGO
        static::creating(function ($ngo) {
            if (empty($ngo->ngo_slug)) {
                $ngo->ngo_slug = self::generateSlug($ngo->ngo_name);
            }
        });
    }

    private static function generateSlug($name)
    {
        // Convertir el nombre a un slug y agregar un número aleatorio de 6 cifras
        return Str::slug($name, '_') . '_' . mt_rand(100000, 999999);
    }
}

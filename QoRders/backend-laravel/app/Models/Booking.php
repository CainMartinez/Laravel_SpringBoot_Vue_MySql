<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Booking extends Model
{
    use HasFactory;

    // Nombre de la tabla
    protected $table = 'Booking';

    // Clave primaria de la tabla
    protected $primaryKey = 'booking_id';

    // Indicar que no es autoincremental
    public $incrementing = true;

    // Tipo de la clave primaria
    protected $keyType = 'int';

    // Timestamps automáticos
    public $timestamps = false;

    // Columnas que se pueden llenar masivamente
    protected $fillable = [
        'booking_uuid',
        'email',
        'room_shift_id',
        'guest_count',
        'status',
        'notes',
        'booking_date',
    ];

    // Relación con RoomShift (N a 1)
    public function roomShift()
    {
        return $this->belongsTo(RoomShift::class, 'room_shift_id', 'room_shift_id');
    }

    // Relación con Orders (1 a N)
    public function orders()
    {
        return $this->hasMany(Order::class, 'booking_id', 'booking_id');
    }

    // Relación 1:1 con QR
    public function qr()
    {
        return $this->hasOne(QR::class, 'booking_id', 'booking_id');
    }

    // Relación 1:1 con Ticket
    public function ticket()
    {
        return $this->hasOne(Ticket::class, 'booking_id', 'booking_id');
    }

    // Scope para filtrar reservas por estado (Pending, Confirmed, InProgress, Completed)
    public function scopeByStatus($query, $status)
    {
        $validStatuses = ['Pending', 'Confirmed', 'InProgress', 'Completed'];

        if (in_array($status, $validStatuses)) {
            return $query->where('status', $status);
        }
        return $query;
    }

    // Scope para filtrar reservas por fecha de reserva
    public function scopeByDate($query, $date)
    {
        return $query->where('booking_date', $date);
    }

}

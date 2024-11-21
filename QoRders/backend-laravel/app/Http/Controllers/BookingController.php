<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class BookingController extends Controller
{
    /**
     * Listar todas las reservas.
     */
    public function index()
    {
        try {
            $bookings = Booking::all();
            return response()->json($bookings, 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to retrieve bookings', 'details' => $e->getMessage()], 500);
        }
    }

    /**
     * Obtener una reserva específica por UUID.
     */
    public function show($uuid)
    {
        try {
            $booking = Booking::where('booking_uuid', $uuid)->first();

            if (!$booking) {
                return response()->json(['error' => 'Booking not found'], 404);
            }

            return response()->json($booking, 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to retrieve booking', 'details' => $e->getMessage()], 500);
        }
    }

    /**
     * Crear una nueva reserva.
     */
    public function store(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'customer_id' => 'required|integer',
                'room_shift_id' => 'required|integer',
                'guest_count' => 'required|integer|min:1',
                'status' => 'in:Pending,Confirmed,Completed',
                'notes' => 'nullable|string',
            ]);

            $validatedData['booking_uuid'] = (string) Str::uuid();

            $booking = Booking::create($validatedData);

            return response()->json($booking, 201);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json(['error' => 'Validation failed', 'details' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to create booking', 'details' => $e->getMessage()], 500);
        }
    }

    /**
     * Actualizar una reserva existente por UUID.
     */
    public function update(Request $request, $uuid)
    {
        try {
            $booking = Booking::where('booking_uuid', $uuid)->first();

            if (!$booking) {
                return response()->json(['error' => 'Booking not found'], 404);
            }

            $validatedData = $request->validate([
                'customer_id' => 'integer',
                'room_shift_id' => 'integer',
                'guest_count' => 'integer|min:1',
                'status' => 'in:Pending,Confirmed,Completed',
                'notes' => 'nullable|string',
            ]);

            $booking->update($validatedData);

            return response()->json($booking, 200);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json(['error' => 'Validation failed', 'details' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to update booking', 'details' => $e->getMessage()], 500);
        }
    }

    /**
     * Eliminar una reserva por UUID.
     */
     public function destroy($uuid)
     {
          try {
               $booking = Booking::where('booking_uuid', $uuid)->first();

               if (!$booking) {
                    return response()->json(['error' => 'Booking not found'], 404);
               }

               $booking->delete();

               return response()->json(['message' => 'Booking deleted successfully'], 200);
          } catch (\Exception $e) {
               return response()->json(['error' => 'Failed to delete booking', 'details' => $e->getMessage()], 500);
          }
     }
}

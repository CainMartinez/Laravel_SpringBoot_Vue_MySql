<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Room;
use App\Models\Waiter;
use App\Models\Booking;
use App\Models\Product;
use App\Models\NGO;

class DashboardController extends Controller
{
     public function getMetrics()
     {
          try {
               // Obtener las métricas
               $metrics = [
                    'total_rooms' => Room::count(),
                    'total_waiters' => Waiter::count(),
                    'bookings' => [
                         'pending' => Booking::where('status', 'Pending')->count(),
                         'confirmed' => Booking::where('status', 'Confirmed')->count(),
                         'completed' => Booking::where('status', 'Completed')->count(),
                    ],
                    'products' => [
                         'active' => Product::where('is_active', 1)->count(),
                         'inactive' => Product::where('is_active', 0)->count(),
                    ],
                    'total_donations' => NGO::sum('total_donations'),
               ];

               // Devolver respuesta con los datos
               return response()->json([
                    'message' => 'Dashboard metrics retrieved successfully',
                    'data' => $metrics
               ], 200);

          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'Failed to retrieve dashboard metrics',
                    'error' => $e->getMessage()
               ], 500);
          }
     }
}

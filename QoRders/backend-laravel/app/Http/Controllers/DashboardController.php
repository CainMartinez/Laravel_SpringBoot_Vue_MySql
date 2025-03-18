<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Room;
use App\Models\Waiter;
use App\Models\Booking;
use App\Models\Product;
use App\Models\NGO;
use App\Models\RoomShift;
use App\Models\QR;
use App\Models\Order;
use App\Models\OrderProduct;
use App\Models\Ticket;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;

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
                    'total_donations' => Ticket::sum('donated_amount'),
                    'total_earnings' => Ticket::sum('total_amount'),
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

     // Obtener las reservas asociadas al camarero logueado
     public function indexBookings()
     {
         try {
              // Obtener email del camarero desde el payload del token
              $payload = JWTAuth::getPayload();
              $email = $payload->get('email');
              
              // Buscar el camarero por email
              $waiter = Waiter::where('email', $email)->firstOrFail();
     
              // Obtener la fecha actual
              $today = \Carbon\Carbon::today()->toDateString();
     
              // Obtener las reservas asociadas a la sala del camarero y ordenarlas:
              // Primero, las que tengan booking_date igual a hoy (true = 1) y luego orden descendente por booking_date
              $bookings = Booking::whereHas('roomShift', function ($query) use ($waiter) {
                   $query->where('room_id', $waiter->room_id);
              })
              ->orderByRaw("booking_date = '$today' DESC")
              ->orderBy('booking_date', 'desc')
              ->get();
     
              if ($bookings->isEmpty()) {
                   return response()->json([
                        'message' => 'No bookings found for this waiter',
                   ], 404);
              }
     
              return response()->json([
                   'message' => 'Bookings retrieved successfully',
                   'data' => $bookings
              ], 200);
     
         } catch (\Exception $e) {
              return response()->json([
                   'message' => 'An unexpected error occurred',
                   'error' => $e->getMessage()
              ], 500);
         }
     }
     

     // Enviar QR de una reserva específica
     public function sendQR($booking_id)
     {
          try {
               // Buscar directamente la reserva por ID
               $booking = Booking::findOrFail($booking_id);

               // Verificar si la reserva está en estado "Confirmed"
               if ($booking->status !== 'Confirmed') {
                    return response()->json([
                         'message' => 'QR can only be generated for Confirmed bookings.'
                    ], 403);  // Código 403: Forbidden
               }

               // Buscar QR asociado
               $qr = $booking->qr;

               if (!$qr) {
                    return response()->json([
                         'message' => 'No QR found for this booking.'
                    ], 404);
               }

               // Verificar si el QR ya fue enviado
               if ($qr->status === 'Printed') {
                    return response()->json([
                         'message' => 'QR has already been sent.',
                         'data' => $qr
                    ], 200);  // Código 200: OK
               }elseif($qr->status === 'In_progress'){
                    return response()->json([
                         'message' => 'QR is in progress.',
                         'data' => $qr
                    ], 200);  // Código 200: OK
               }elseif($qr->status === 'Expired'){
                    return response()->json([
                         'message' => 'QR is expired.',
                         'data' => $qr
                    ], 409);  // Código 409: Conflict
               }

               $qr->status = 'Printed';
               $qr->save();

               return response()->json([
                    'message' => 'QR sent successfully.',
                    'data' => $qr
               ], 200);

          } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
               return response()->json([
                    'message' => 'Booking not found or does not belong to this waiter.',
                    'booking_id' => $booking_id
               ], 404);  // Código 404: Not Found

          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred.',
                    'error' => $e->getMessage()
               ], 500);  // Código 500: Internal Server Error
          }
     }

     // Obtener el ticket completo de una reserva Completed
     public function showTicket($booking_id)
     {
          try {
               // 1. Verificar si la reserva existe y tiene el estado "Completed"
               $booking = Booking::findOrFail($booking_id);

               if ($booking->status !== 'Completed') {
                    return response()->json([
                         'message' => 'Tickets are only available for Completed bookings.'
                    ], 403);  // Código 403: Forbidden
               }

               // 2. Buscar el ticket asociado a la reserva
               $ticket = $booking->ticket;

               if (!$ticket) {
                    return response()->json([
                         'message' => 'No ticket found for this booking.'
                    ], 404);  // Código 404: Not Found
               }

               // 3. Obtener todas las órdenes relacionadas con la reserva
               $orders = $booking->orders()->get();

               // 4. Formar la estructura del ticket
               $response = [
                    'ticket' => $ticket,
                    'orders' => $orders->map(function ($order) {
                         return [
                              'order_id' => $order->order_id,
                              'total_amount' => $order->total_amount,
                              'products' => $order->orderProducts->map(function ($orderProduct) {
                              $product = $orderProduct->product;
                              return [
                                   'product_name' => $product->product_name,
                                   'product_quantity' => $orderProduct->quantity,
                                   'unit_price' => $product->unit_price,
                                   'subtotal' => $orderProduct->quantity * $product->unit_price,
                              ];
                              }),
                         ];
                    }),
               ];

               return response()->json([
                    'message' => 'Ticket retrieved successfully.',
                    'data' => $response
               ], 200);

          } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
               return response()->json([
                    'message' => 'Booking not found.',
                    'booking_id' => $booking_id
               ], 404);  // Código 404: Not Found

          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred.',
                    'error' => $e->getMessage()
               ], 500);  // Código 500: Internal Server Error
          }
     }

     //Obtener todas las comandas de una reserva InProgress
     public function indexOrders($booking_id)
     {
          try {
               // Buscar la reserva por ID
               $booking = Booking::findOrFail($booking_id);

               // Verificar que la reserva esté en estado "InProgress"
               if ($booking->status !== 'InProgress') {
                    return response()->json([
                         'message' => 'You can only check orders for InProgress bookings.'
                    ], 403);  // Código 403: Forbidden
               }

               // Obtener todas las órdenes asociadas a esa reserva
               $orders = $booking->orders()->with('orderProducts.product')->get();

               // Verificar si hay órdenes asociadas
               if ($orders->isEmpty()) {
                    return response()->json([
                         'message' => 'No orders found for this booking.'
                    ], 404);
               }

               // Formar la respuesta con los detalles de las órdenes y productos
               $response = $orders->map(function ($order) {
                    // Calcular la diferencia en minutos entre created_at y ahora
                    $waitingTime = now()->diffInMinutes($order->created_at);

                    return [
                         'order_id' => $order->order_id,
                         'order_status' => $order->order_status,
                         'waiting_for' => $waitingTime . ' minutes',  // Añadimos la diferencia en minutos
                         'products' => $order->orderProducts->map(function ($orderProduct) {
                              return [
                              'product_name' => $orderProduct->product->product_name,
                              'quantity' => $orderProduct->quantity
                              ];
                         }),
                    ];
               });

               return response()->json([
                    'message' => 'Orders retrieved successfully.',
                    'data' => $response
               ], 200);

          } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
               return response()->json([
                    'message' => 'Booking not found.',
                    'booking_id' => $booking_id
               ], 404);

          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred.',
                    'error' => $e->getMessage()
               ], 500);
          }
     }

     // Asignar comanda (Order_status -> Waiting to Assigned)
     public function assignOrder($order_id)
     {
          try {
               // Buscar la orden por ID
               $order = Order::findOrFail($order_id);

               // Validar que el estado actual sea "Waiting"
               if ($order->order_status !== 'Waiting') {
                    return response()->json([
                         'message' => 'Only orders in Waiting status can be assigned.',
                         'current_status' => $order->order_status
                    ], 403);  // Código 403: Forbidden
               }

               // Actualizar el estado a "Assigned"
               $order->order_status = 'Assigned';
               $order->save();

               return response()->json([
                    'message' => 'Order assigned successfully.',
                    'data' => $order
               ], 200);

          } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
               return response()->json([
                    'message' => 'Order not found.',
                    'order_id' => $order_id
               ], 404);  // Código 404: Not Found

          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred.',
                    'error' => $e->getMessage()
               ], 500);  // Código 500: Internal Server Error
          }
     }

     // Entregar comanda (Order_status -> Assigned to Delivered)
     public function deliverOrder($order_id)
     {
          try {
               // Buscar la orden por ID
               $order = Order::findOrFail($order_id);

               // Validar que el estado actual sea "Assigned"
               if ($order->order_status !== 'Assigned') {
                    return response()->json([
                         'message' => 'Only orders in Assigned status can be delivered.',
                         'current_status' => $order->order_status
                    ], 403);  // Código 403: Forbidden
               }

               // Actualizar el estado a "Delivered"
               $order->order_status = 'Delivered';
               $order->save();

               return response()->json([
                    'message' => 'Order delivered successfully.',
                    'data' => $order
               ], 200);

          } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
               return response()->json([
                    'message' => 'Order not found.',
                    'order_id' => $order_id
               ], 404);  // Código 404: Not Found

          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred.',
                    'error' => $e->getMessage()
               ], 500);  // Código 500: Internal Server Error
          }
     }

}

<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Waiter;
use App\Models\Room;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class WaiterController extends Controller
{
     // Listar todos los camareros
     public function index()
     {
          $waiters = Waiter::with('room')->get();

          if ($waiters->isEmpty()) {
               return response()->json(['message' => 'No waiters found'], 404);
          }

          return response()->json([
               'message' => 'Waiters retrieved successfully',
               'data' => $waiters
          ], 200);
     }

     // Obtener un camarero por su email
     public function indexByEmail($email)
     {
          try {
               $waiter = Waiter::where('email', $email)->with('room')->firstOrFail();

               return response()->json([
                    'message' => 'Waiter retrieved successfully',
                    'data' => $waiter
               ], 200);
          } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
               return response()->json([
                    'message' => 'Waiter not found',
                    'email' => $email
               ], 404);
          }
     }

     public function store(Request $request)
     {
          try {
               // Validación de datos
               $validated = $request->validate([
                    'firstName' => 'required|string|max:100',
                    'lastName' => 'required|string|max:100',
                    'email' => 'required|email|max:150',
                    'password' => 'required|string|min:6',
                    'repeat_password' => 'required|string|min:6|same:password',
                    'salary' => 'required|numeric|min:500',
                    'shift_disponibility' => 'required|in:Lunch,Dinner,Flexible',
                    'room_id' => 'required|exists:Room,room_id',
               ]);

               // Comprobar si ya existe un camarero con el mismo email
               $existingWaiter = Waiter::where('email', $validated['email'])->first();
               if ($existingWaiter) {
                    return response()->json([
                         'message' => 'A waiter with this email already exists.',
                    ], 409);  // Código 409: Conflict
               }

               // Hashear la contraseña con Argon2
               $validated['password'] = Hash::make($validated['password'], [
                    'rounds' => 12,
               ]);

               // Eliminar repeat_password del array validado
               unset($validated['repeat_password']);

               // Asignar hire_date automáticamente
               $validated['hire_date'] = now();

               // Generar avatar usando pravatar basado en el email
               $validated['avatar_url'] = "https://i.pravatar.cc/150?u=" . md5(strtolower(trim($validated['email'])));

               // Creación del camarero
               $waiter = Waiter::create($validated);

               return response()->json([
                    'message' => 'Waiter created successfully',
                    'data' => $waiter
               ], 201);  // Código 201: Created

          } catch (ValidationException $e) {
               return response()->json([
                    'message' => 'Validation failed',
                    'errors' => $e->errors()
               ], 422);  // Código 422: Unprocessable Entity
          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred',
                    'error' => $e->getMessage()
               ], 500);
          }
     }
     // Actualizar datos de un camarero
     public function update(Request $request, $email)
     {
          try {
               $validated = $request->validate([
                    'salary' => 'nullable|numeric|min:500',
                    'shift_disponibility' => 'nullable|in:Lunch,Dinner,Flexible',
                    'room_id' => 'nullable|exists:Room,room_id',
               ]);

               $waiter = Waiter::where('email', $email)->firstOrFail();

               // Filtrar solo campos que han cambiado
               $updateData = [];
               foreach ($validated as $key => $value) {
                    if (!is_null($value) && $value !== '' && $waiter->$key !== $value) {
                         $updateData[$key] = $value;
                    }
               }

               if (empty($updateData)) {
                    return response()->json([
                         'message' => 'No changes detected',
                         'data' => $waiter
                    ], 200);
               }

               $waiter->update($updateData);

               return response()->json([
                    'message' => 'Waiter updated successfully',
                    'data' => $waiter
               ], 200);
               
          } catch (ValidationException $e) {
               return response()->json([
                    'message' => 'Validation failed',
                    'errors' => $e->errors()
               ], 422);
               
          } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
               return response()->json([
                    'message' => 'Waiter not found',
                    'email' => $email
               ], 404);

          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred',
                    'error' => $e->getMessage()
               ], 500);
          }
     }

     // Habilitar un camarero (poner is_active a 1)
     public function enable($email)
     {
          try {
               $waiter = Waiter::where('email', $email)->firstOrFail();

               if ($waiter->is_active) {
                    return response()->json([
                         'message' => 'Waiter is already enabled',
                         'data' => $waiter
                    ], 200);
               }

               $waiter->update(['is_active' => 1]);

               return response()->json([
                    'message' => 'Waiter has been enabled successfully',
                    'data' => $waiter
               ], 200);
          } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
               return response()->json([
                    'message' => 'Waiter not found',
                    'email' => $email
               ], 404);
          }
     }

     // Deshabilitar un camarero (poner is_active a 0)
     public function disable($email)
     {
          try {
               $waiter = Waiter::where('email', $email)->firstOrFail();

               if (!$waiter->is_active) {
                    return response()->json([
                         'message' => 'Waiter is already disabled',
                         'data' => $waiter
                    ], 200);
               }

               $waiter->update(['is_active' => 0]);

               return response()->json([
                    'message' => 'Waiter has been disabled successfully',
                    'data' => $waiter
               ], 200);
          } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
               return response()->json([
                    'message' => 'Waiter not found',
                    'email' => $email
               ], 404);
          }
     }
}

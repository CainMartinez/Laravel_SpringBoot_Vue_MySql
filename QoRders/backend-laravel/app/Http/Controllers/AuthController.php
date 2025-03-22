<?php

namespace App\Http\Controllers;

use App\Models\Waiter;
use App\Models\Manager;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;
use Illuminate\Support\Facades\Redis;
use Illuminate\Support\Facades\DB;

class AuthController extends Controller
{
     // Registro de usuarios
     public function register(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'role' => 'required|string|in:waiter,manager',
               'firstName' => 'required|string|max:100',
               'lastName' => 'required|string|max:100',
               'email' => 'required|string|email|max:150|unique:' . ($request->role === 'waiter' ? 'Waiter' : 'Manager') . ',email',
               'password' => 'required|string|min:6',
               'repeatPassword' => 'required|same:password',
          ], [
               'repeatPassword.same' => 'The repeatPassword must match the password.',
          ]);

          if ($validator->fails()) {
               return response()->json([
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
               ], 422);
          }

          try {
               // Generar el avatar_url utilizando el rol y el email
               $avatarUrl = $this->generateAvatarUrl($request->role, $request->email);

               $roomId = rand(1, 6);
               // Crear el usuario según el role
               $user = $request->role === 'waiter'
                    ? Waiter::create([
                         'firstName' => $request->firstName,
                         'lastName' => $request->lastName,
                         'email' => $request->email,
                         'password' => Hash::make($request->password),
                         'waiter_uuid' => \Illuminate\Support\Str::uuid(),
                         'hire_date' => now()->toDateString(),
                         'avatar_url' => $avatarUrl,
                         'room_id' => $roomId,
                    ])
                    : Manager::create([
                         'firstName' => $request->firstName,
                         'lastName' => $request->lastName,
                         'email' => $request->email,
                         'password' => Hash::make($request->password),
                         'manager_uuid' => \Illuminate\Support\Str::uuid(),
                         'avatar_url' => $avatarUrl,
                    ]);

               return response()->json([
                    'message' => ucfirst($request->role) . ' registered successfully.',
               ], 201);
          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred during registration.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     // Login de usuarios
     public function login(Request $request)
     {
          // Validar los datos de entrada
          $validator = Validator::make($request->all(), [
               'role' => 'required|string|in:waiter,manager',
               'email' => 'required|string|email',
               'password' => 'required|string',
          ]);

          if ($validator->fails()) {
               return response()->json([
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
               ], 422);
          }

          try {
               // Buscar usuario según el rol
               $user = $request->role === 'waiter'
                    ? Waiter::where('email', $request->email)->first()
                    : Manager::where('email', $request->email)->first();

               // Comprobar si el email existe
               if (!$user) {
                    return response()->json([
                         'message' => 'The email address does not exist in our records.',
                    ], 404); // HTTP 404 Not Found
               }

               // Comprobar si la contraseña es incorrecta
               if (!Hash::check($request->password, $user->password)) {
                    return response()->json([
                         'message' => 'The password is incorrect.',
                    ], 401); // HTTP 401 Unauthorized
               }

               // Generar el token JWT
               $token = JWTAuth::claims([
                    'email' => $user->email,
                    'role' => $request->role,
               ])->fromUser($user);

               // Crear clave para Redis y datos del usuario
               $redisKey = "logged_{$request->role}_{$user->email}";
               // Convertir el modelo a un array con todos los campos
               $redisData = [
                    $request->role => $user,
                    'token' => $token,
               ];

               // Guardar en Redis con TTL igual a JWT_TTL
               $ttl = config('jwt.ttl') * 60; // Convertir minutos a segundos
               Redis::set($redisKey, json_encode($redisData));
               Redis::expire($redisKey, $ttl);

               // Respuesta exitosa
               return response()->json($token, 200);
          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred during login.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     // Obtener perfil del usuario autenticado
     public function me()
     {
          try {
               // Obtener el payload del token JWT
               $payload = JWTAuth::getPayload();
               $role = $payload->get('role'); // Obtener el rol del token
               $email = $payload->get('email'); // Obtener el email del token

               // Generar la clave de Redis
               $redisKey = "logged_{$role}_{$email}";

               // Comprobar si la clave existe en Redis
               if (Redis::exists($redisKey)) {
                    // Obtener los datos del usuario de Redis
                    $userData = json_decode(Redis::get($redisKey), true);
                    return response()->json(
                         $userData,
                    200);
               }

               // Si no se encuentra la clave en Redis
               return response()->json([
                    'message' => 'User data not found in Redis.',
               ], 404);
          } catch (\Exception $e) {
               // Manejar errores y excepciones
               return response()->json([
                    'error' => 'An error occurred while verifying data in Redis.',
                    'details' => $e->getMessage(),
               ], 500);
          }
     }

     // Refrescar token
     public function refresh()
     {
          try {
               $token = JWTAuth::getToken();

               if (!$token) {
                    return response()->json([
                         'message' => 'No token provided',
                    ], 400);
               }

               return response()->json([
                    'message' => 'Token refreshed successfully',
                    'token' => JWTAuth::refresh($token),
               ], 200);
          } catch (\Exception $e) {
               \Log::error('Error refreshing token:', ['error' => $e->getMessage()]);
               return response()->json([
                    'message' => 'An unexpected error occurred while refreshing the token.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     // Logout de usuarios
     public function logout()
     {
          try {
               // Obtener el token del encabezado de la solicitud
               $token = JWTAuth::getToken();

               // Verificar que el token exista
               if (!$token) {
                    return response()->json([
                         'message' => 'No token provided',
                    ], 400);
               }

               // Obtener el payload del token
               $payload = JWTAuth::getPayload();
               $role = $payload->get('role'); // Obtener el rol del token
               $email = $payload->get('email'); // Obtener el email del token

               // Generar la clave en Redis
               $redisKey = "logged_{$role}_{$email}";

               // Eliminar el registro de Redis
               if (Redis::exists($redisKey)) {
                    if(Redis::del($redisKey)){ // Borra la clave de Redis
                         // Invalidar el token
                         JWTAuth::invalidate($token);

                         return response()->json([
                              'message' => $role . ' logged out successfully.',
                         ], 200);
                    }else{
                         return response()->json([
                              'message' => 'Error deleting Redis data.',
                         ], 500);
                    }
               }else{
                    return response()->json([
                         'message' => 'User data not found in Redis.',
                    ], 404);
               }

          } catch (\Exception $e) {
               // Manejar errores y excepciones
               \Log::error('Error during logout:', ['error' => $e->getMessage()]);
               return response()->json([
                    'message' => 'An unexpected error occurred during logout.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     public function updateWaiter(Request $request)
     {
          // Obtener el payload del token
          $payload = JWTAuth::getPayload();
          $email = $payload->get('email');
          $role = $payload->get('role');

          try {
               // Validar los datos recibidos
               $validator = Validator::make($request->all(), [
                    'firstName' => 'string|max:100',
                    'lastName' => 'string|max:100',
                    'phone_number' => 'string|nullable|max:15',
                    'shift_disponibility' => 'in:Lunch,Dinner,Flexible',
                    'bio' => 'string|nullable',
                    'avatar_url' => 'string|nullable',
               ]);

               if ($validator->fails()) {
                    return response()->json([
                         'message' => 'Validation failed',
                         'errors' => $validator->errors(),
                    ], 422);
               }

               // Filtrar solo los campos presentes en la request
               $updateData = array_filter($request->only([
                    'firstName',
                    'lastName',
                    'phone_number',
                    'shift_disponibility',
                    'bio',
                    'avatar_url',
               ]), function ($value) {
                    return !is_null($value); // Solo incluir campos que no sean nulos
               });

               // Iniciar una transacción para garantizar consistencia
               DB::beginTransaction();

               // Buscar el camarero en la base de datos
               $waiter = Waiter::where('email', $email)->first();

               if (!$waiter) {
                    DB::rollBack(); // Revertir cambios si no se encuentra el camarero
                    return response()->json([
                         'message' => 'Waiter not found',
                    ], 404);
               }

               // Actualizar solo los campos enviados
               $waiter->update($updateData);

               // Generar la clave en Redis
               $redisKey = "logged_waiter_{$email}";

               // Recuperar el registro existente desde Redis
               $existingData = Redis::get($redisKey);
               if ($existingData) {
                    // Decodificar los datos existentes
                    $decodedData = json_decode($existingData, true);

                    // Verificar si el campo 'waiter' existe en el registro
                    if (isset($decodedData['waiter'])) {
                         // Actualizar solo los campos enviados en la request dentro del objeto 'waiter'
                         $decodedData['waiter'] = array_merge($decodedData['waiter'], $updateData);

                         // Guardar los datos actualizados en Redis
                         Redis::set($redisKey, json_encode($decodedData));

                         // Extender el TTL del registro en Redis
                         $ttl = Redis::ttl($redisKey); // Obtén el TTL actual
                         if ($ttl > 0) { // Asegúrate de que el TTL sea válido
                              Redis::expire($redisKey, $ttl); // Renueva el TTL al mismo tiempo
                         }

                         // Confirmar la transacción
                         DB::commit();

                        // Recuperar el registro actualizado completo desde Redis
                         $updatedRecord = json_decode(Redis::get($redisKey), true);
                         $ttl = config('jwt.ttl') * 60; // Convertir minutos a segundos
                         Redis::expire($redisKey, $ttl);

                         // Responder con el mensaje de éxito y los datos actualizados en Redis
                         return response()->json([
                         'message' => 'Waiter profile updated successfully',
                         'waiter' => $updatedRecord['waiter'], 
                         'token' => $updatedRecord['token'],  
                         ], 200);
                    }

                    DB::rollBack(); // Revertir cambios si no se encuentra el objeto waiter en Redis
                    return response()->json([
                         'message' => 'No waiter object found in Redis record',
                    ], 404);
               }

               // Manejar el error si no existe el registro en Redis
               DB::rollBack();
               return response()->json([
                    'message' => 'Redis record not found for the given waiter',
               ], 404);
          } catch (\Exception $e) {
               DB::rollBack(); // Asegurar la reversión en caso de error
               \Log::error('Error during waiter update:', ['error' => $e->getMessage()]);
               return response()->json([
                    'message' => 'An unexpected error occurred during waiter update.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     public function updateManager(Request $request)
     {
          // Obtener el payload del token
          $payload = JWTAuth::getPayload();
          $email = $payload->get('email');
          $role = $payload->get('role');

          try {
               // Validar los datos recibidos
               $validator = Validator::make($request->all(), [
                    'firstName' => 'string|max:100',
                    'lastName' => 'string|max:100',
                    'phone_number' => 'string|nullable|max:15',
                    'address' => 'string|nullable',
                    'bio' => 'string|nullable',
                    'avatar_url' => 'string|nullable',
               ]);

               if ($validator->fails()) {
                    return response()->json([
                         'message' => 'Validation failed',
                         'errors' => $validator->errors(),
                    ], 422);
               }

               // Filtrar solo los campos presentes en la request
               $updateData = array_filter($request->only([
                    'firstName',
                    'lastName',
                    'phone_number',
                    'address',
                    'bio',
                    'avatar_url',
               ]), function ($value) {
                    return !is_null($value); // Solo incluir campos que no sean nulos
               });

               // Iniciar una transacción para garantizar consistencia
               DB::beginTransaction();

               // Buscar el manager en la base de datos
               $manager = Manager::where('email', $email)->first();

               if (!$manager) {
                    DB::rollBack(); // Revertir cambios si no se encuentra el manager
                    return response()->json([
                         'message' => 'Manager not found',
                    ], 404);
               }

               // Actualizar solo los campos enviados
               $manager->update($updateData);

               // Generar la clave en Redis
               $redisKey = "logged_manager_{$email}";

               // Recuperar el registro existente desde Redis
               $existingData = Redis::get($redisKey);
               if ($existingData) {
                    // Decodificar los datos existentes
                    $decodedData = json_decode($existingData, true);

                    // Verificar si el campo 'manager' existe en el registro
                    if (isset($decodedData['manager'])) {
                         // Actualizar solo los campos enviados en la request dentro del objeto 'manager'
                         $decodedData['manager'] = array_merge($decodedData['manager'], $updateData);

                         // Guardar los datos actualizados en Redis
                         Redis::set($redisKey, json_encode($decodedData));

                         // Extender el TTL del registro en Redis
                         $ttl = Redis::ttl($redisKey); // Obtén el TTL actual
                         if ($ttl > 0) { // Asegúrate de que el TTL sea válido
                              Redis::expire($redisKey, $ttl); // Renueva el TTL al mismo tiempo
                         }

                         // Confirmar la transacción
                         DB::commit();

                         // Recuperar el registro actualizado completo desde Redis
                         $updatedRecord = json_decode(Redis::get($redisKey), true);
                         $ttl = config('jwt.ttl') * 60; // Convertir minutos a segundos
                         Redis::expire($redisKey, $ttl);

                         // Responder con el mensaje de éxito y los datos actualizados en Redis
                         return response()->json([
                              'message' => 'Manager profile updated successfully',
                              'manager' => $updatedRecord['manager'], 
                              'token' => $updatedRecord['token'],  
                         ], 200);
                    }

                    DB::rollBack(); // Revertir cambios si no se encuentra el objeto manager en Redis
                    return response()->json([
                         'message' => 'No manager object found in Redis record',
                    ], 404);
               }

               // Manejar el error si no existe el registro en Redis
               DB::rollBack();
               return response()->json([
                    'message' => 'Redis record not found for the given manager',
               ], 404);
          } catch (\Exception $e) {
               DB::rollBack(); // Asegurar la reversión en caso de error
               \Log::error('Error during manager update:', ['error' => $e->getMessage()]);
               return response()->json([
                    'message' => 'An unexpected error occurred during manager update.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     // Generar URL de avatar
     private function generateAvatarUrl(string $role, string $email): string
     {
          $uniqueIdentifier = md5(strtolower(trim($role . $email))); // Crear identificador único
          return "https://i.pravatar.cc/300?u={$uniqueIdentifier}";
     }
}

<?php

namespace App\Http\Controllers;

use App\Models\Waiter;
use App\Models\Manager;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;

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

               // Crear el usuario según el role
               $user = $request->role === 'waiter'
                    ? Waiter::create([
                         'firstName' => $request->firstName,
                         'lastName' => $request->lastName,
                         'email' => $request->email,
                         'password' => Hash::make($request->password),
                         'waiter_uuid' => \Illuminate\Support\Str::uuid(),
                         'hire_date' => now()->toDateString(),
                         'avatar_url' => $avatarUrl, // Añadir el avatar URL
                    ])
                    : Manager::create([
                         'firstName' => $request->firstName,
                         'lastName' => $request->lastName,
                         'email' => $request->email,
                         'password' => Hash::make($request->password),
                         'manager_uuid' => \Illuminate\Support\Str::uuid(),
                         'avatar_url' => $avatarUrl, // Añadir el avatar URL
                    ]);

               return response()->json([
                    'message' => ucfirst($request->role) . ' registered successfully',
                    'user' => $user,
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

               // Respuesta exitosa
               return response()->json([
                    "message" => "Login successful",
                    "token" => $token,
                    "user" => [
                         "uuid" => $request->role === 'waiter' ? $user->waiter_uuid : $user->manager_uuid,
                         "firstName" => $user->firstName,
                         "lastName" => $user->lastName,
                         "email" => $user->email,
                         "role" => $request->role,
                         "avatar_url" => $user->avatar_url,
                    ],
               ], 200);
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
               $payload = JWTAuth::getPayload();
               $role = $payload->get('role');
               $email = $payload->get('email');

               $user = $role === 'waiter'
                    ? Waiter::where('email', $email)->first()
                    : Manager::where('email', $email)->first();

               if (!$user) {
                    return response()->json(['message' => 'User not found'], 404);
               }

               return response()->json([
                    'message' => 'User profile retrieved successfully',
                    'user' => $user,
                    'role' => $role,
               ], 200);
          } catch (\Exception $e) {
               return response()->json(['error' => $e->getMessage()], 500);
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
               $token = JWTAuth::getToken();

               if (!$token) {
                    return response()->json([
                         'message' => 'No token provided',
                    ], 400);
               }

               JWTAuth::invalidate($token);

               return response()->json([
                    'message' => 'Logout successful',
               ], 200);
          } catch (\Exception $e) {
               \Log::error('Error during logout:', ['error' => $e->getMessage()]);
               return response()->json([
                    'message' => 'An unexpected error occurred during logout.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     private function generateAvatarUrl(string $role, string $email): string
     {
          $uniqueIdentifier = md5(strtolower(trim($role . $email))); // Crear identificador único
          return "https://i.pravatar.cc/300?u={$uniqueIdentifier}";
     }
}

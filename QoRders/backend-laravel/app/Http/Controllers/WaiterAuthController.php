<?php

namespace App\Http\Controllers;

use App\Models\Waiter;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;

class WaiterAuthController extends Controller
{
     // Registro de camareros
     public function register(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'firstName' => 'required|string|max:100',
               'lastName' => 'required|string|max:100',
               'email' => 'required|string|email|max:150|unique:Waiter,email',
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
               $waiter = Waiter::create([
                    'firstName' => $request->firstName,
                    'lastName' => $request->lastName,
                    'email' => $request->email,
                    'password' => Hash::make($request->password),
                    'waiter_uuid' => \Illuminate\Support\Str::uuid(),
                    'hire_date' => now()->toDateString(),
               ]);

               return response()->json([
                    'message' => 'Waiter registered successfully',
                    'waiter' => [
                         'id' => $waiter->waiter_id,
                         'uuid' => $waiter->waiter_uuid,
                         'firstName' => $waiter->firstName,
                         'lastName' => $waiter->lastName,
                         'email' => $waiter->email,
                         'hire_date' => $waiter->hire_date,
                    ],
               ], 201);
          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred during registration.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     // Login de camareros
     public function login(Request $request)
     {
          try {
               $credentials = $request->only('email', 'password');
               
                // Verificar las credenciales que llegan al método
               \Log::info('Credentials: ', $credentials);

               if (!$token = auth('waiters')->attempt($credentials)) {
                    return response()->json([
                         'message' => 'Unauthorized. Invalid email or password.',
                    ], 401);
               }

               $waiter = auth('waiters')->user();

               return response()->json([
                    'message' => 'Login successful',
                    'token' => $token,
                    'user' => [
                         'id' => $waiter->waiter_id,
                         'uuid' => $waiter->waiter_uuid,
                         'firstName' => $waiter->firstName,
                         'lastName' => $waiter->lastName,
                         'email' => $waiter->email,
                         'is_active' => $waiter->is_active,
                         'role' => 'Waiter',
                    ],
               ], 200);
          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred during login.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     // Obtener el perfil del camarero autenticado
     public function me()
     {
          try {
               return response()->json([
                    'message' => 'User profile retrieved successfully',
                    'user' => JWTAuth::user(),
               ], 200);
          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred while retrieving the profile.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     // Refrescar token
     public function refresh()
     {
          try {
               return response()->json([
                    'message' => 'Token refreshed successfully',
                    'token' => JWTAuth::refresh(),
               ], 200);
          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred while refreshing the token.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     // Logout del camarero
     public function logout()
     {
          try {
               JWTAuth::invalidate(JWTAuth::getToken());

               return response()->json([
                    'message' => 'Logout successful',
               ], 200);
          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred during logout.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }
}

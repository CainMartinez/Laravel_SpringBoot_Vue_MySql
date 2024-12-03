<?php

namespace App\Http\Controllers;

use App\Models\Manager;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;

class ManagerAuthController extends Controller
{
     // Registro de administradores
     public function register(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'first_name' => 'required|string|max:100',
               'last_name' => 'required|string|max:100',
               'email' => 'required|string|email|max:150|unique:Manager,email',
               'password' => 'required|string|min:6',
               'repeat_password' => 'required|same:password',
          ], [
               'repeat_password.same' => 'The repeat_password must match the password.',
          ]);

          if ($validator->fails()) {
               return response()->json([
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
               ], 422);
          }

          try {
               $manager = Manager::create([
                    'first_name' => $request->first_name,
                    'last_name' => $request->last_name,
                    'email' => $request->email,
                    'password' => Hash::make($request->password),
                    'manager_uuid' => \Illuminate\Support\Str::uuid(),
               ]);

               return response()->json([
                    'message' => 'Manager registered successfully',
                    'manager' => [
                         'id' => $manager->manager_id,
                         'uuid' => $manager->manager_uuid,
                         'first_name' => $manager->first_name,
                         'last_name' => $manager->last_name,
                         'email' => $manager->email,
                    ],
               ], 201);
          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred during registration.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     // Login de administradores
     public function login(Request $request)
     {
          try {
               $credentials = $request->only('email', 'password');

               if (!$token = auth('managers')->attempt($credentials)) {
                    return response()->json([
                         'message' => 'Unauthorized. Invalid email or password.',
                    ], 401);
               }

               $manager = auth('managers')->user();

               return response()->json([
                    'message' => 'Login successful',
                    'token' => $token,
                    'user' => [
                         'id' => $manager->manager_id,
                         'uuid' => $manager->manager_uuid,
                         'first_name' => $manager->first_name,
                         'last_name' => $manager->last_name,
                         'email' => $manager->email,
                         'is_active' => $manager->is_active,
                         'role' => 'Manager',
                    ],
               ], 200);
          } catch (\Exception $e) {
               return response()->json([
                    'message' => 'An unexpected error occurred during login.',
                    'error' => $e->getMessage(),
               ], 500);
          }
     }

     // Obtener el perfil del administrador autenticado
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

     // Logout del administrador
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

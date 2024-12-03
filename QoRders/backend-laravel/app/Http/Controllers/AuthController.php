<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Waiter;
use App\Models\Manager;

class AuthController extends Controller
{
    // Registro para Waiters
     public function registerWaiter(Request $request)
     {
          $request->validate([
               'first_name' => 'required|string|max:100',
               'last_name' => 'required|string|max:100',
               'email' => 'required|email|unique:Waiter,email',
               'password' => 'required|string|min:6|confirmed',
          ]);

          $waiter = Waiter::create([
               'waiter_uuid' => (string) \Str::uuid(),
               'first_name' => $request->first_name,
               'last_name' => $request->last_name,
               'email' => $request->email,
               'password' => bcrypt($request->password), // Encriptamos la contraseña
          ]);

          return response()->json([
               'message' => 'Waiter registered successfully',
               'data' => $waiter,
          ], 201);
     }

     // Registro para Managers
     public function registerManager(Request $request)
     {
          $request->validate([
               'first_name' => 'required|string|max:100',
               'last_name' => 'required|string|max:100',
               'email' => 'required|email|unique:Manager,email',
               'password' => 'required|string|min:6|confirmed',
          ]);

          $manager = Manager::create([
               'manager_uuid' => (string) \Str::uuid(),
               'first_name' => $request->first_name,
               'last_name' => $request->last_name,
               'email' => $request->email,
               'password' => bcrypt($request->password), // Encriptamos la contraseña
          ]);

          return response()->json([
               'message' => 'Manager registered successfully',
               'data' => $manager,
          ], 201);
     }

     // Login común (detecta automáticamente el tipo de usuario)
     public function login(Request $request)
     {
          $request->validate([
               'email' => 'required|email',
               'password' => 'required|string',
          ]);

          // Intentamos loguear como Waiter
          if ($token = Auth::guard('waiter')->attempt($request->only('email', 'password'))) {
               return $this->respondWithToken($token, 'waiter');
          }

          // Intentamos loguear como Manager
          if ($token = Auth::guard('manager')->attempt($request->only('email', 'password'))) {
               return $this->respondWithToken($token, 'manager');
          }

          return response()->json(['message' => 'Unauthorized'], 401);
     }

     // Obtener información del usuario autenticado
     public function me()
     {
          $user = Auth::user();

          return response()->json([
               'message' => 'User retrieved successfully',
               'data' => $user,
          ]);
     }

     // Logout
     public function logout()
     {
          Auth::logout();

          return response()->json(['message' => 'Logged out successfully']);
     }

     // Refrescar token
     public function refresh()
     {
          $newToken = Auth::refresh();

          return $this->respondWithToken($newToken, Auth::user()->role);
     }

     // Respuesta con token
     protected function respondWithToken($token, $role)
     {
          return response()->json([
               'access_token' => $token,
               'token_type' => 'bearer',
               'expires_in' => Auth::factory()->getTTL() * 60, // Tiempo de expiración en segundos
               'role' => $role,
          ]);
     }
}

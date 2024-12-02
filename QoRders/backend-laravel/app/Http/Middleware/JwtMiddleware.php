<?php

namespace App\Http\Middleware;

use Closure;
use PHPOpenSourceSaver\JWTAuth\Exceptions\JWTException;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;
use Illuminate\Http\Request;

class JwtMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle(Request $request, Closure $next)
    {
        try {
            // Intentar autenticar el token
            if (!$user = JWTAuth::parseToken()->authenticate()) {
                return response()->json([
                    'message' => 'User not found',
                ], 404);
            }
        } catch (JWTException $e) {
            $status = $e instanceof \PHPOpenSourceSaver\JWTAuth\Exceptions\TokenExpiredException
                ? 401 // Token expirado
                : ($e instanceof \PHPOpenSourceSaver\JWTAuth\Exceptions\TokenInvalidException ? 400 : 500);

            return response()->json([
                'message' => 'Token error: ' . $e->getMessage(),
            ], $status);
        }

        // Pasar la solicitud al siguiente middleware o controlador
        return $next($request);
    }
}

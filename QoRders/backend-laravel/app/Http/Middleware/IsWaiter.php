<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class IsWaiter
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Illuminate\Http\Response|\Illuminate\Http\RedirectResponse)  $next
     * @return \Illuminate\Http\Response|\Illuminate\Http\RedirectResponse
     */
    
    public function handle(Request $request, Closure $next)
    {
        try {
            $role = JWTAuth::parseToken()->getPayload()->get('role');

            if ($role !== 'waiter') {
                return response()->json(['error' => 'Unauthorized for waiter'], 403);
            }

            return $next($request);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Token error: ' . $e->getMessage()], 401);
        }
    }
}

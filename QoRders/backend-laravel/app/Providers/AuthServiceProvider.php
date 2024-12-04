<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Auth;
use App\Auth\JwtGuard;

class AuthServiceProvider extends ServiceProvider
{
     public function boot()
     {
          // Extender el guard para JWT
          Auth::extend('jwt', function ($app, $name, array $config) {
               return new JwtGuard(
                    Auth::createUserProvider($config['provider']),
                    $app['request']
               );
          });
     }
}

<?php

return [

     /*
     |--------------------------------------------------------------------------
     | Default Hasher
     |--------------------------------------------------------------------------
     |
     | This option controls the default hash driver that will be used to hash
     | passwords for your application. By default, the bcrypt algorithm is
     | used; however, you remain free to modify this option if you wish.
     |
     | Supported: "bcrypt", "argon", "argon2id"
     |
     */

     'driver' => 'argon',

     /*
     |--------------------------------------------------------------------------
     | Bcrypt Options
     |--------------------------------------------------------------------------
     |
     | Here you may specify the configuration options that should be used
     | when passwords are hashed using the Bcrypt algorithm.
     |
     */

     'bcrypt' => [
          'rounds' => env('BCRYPT_ROUNDS', 10),
     ],

     /*
     |--------------------------------------------------------------------------
     | Argon Options
     |--------------------------------------------------------------------------
     |
     | Here you may specify the configuration options that should be used when
     | passwords are hashed using the Argon algorithm. These will allow you to
     | control memory cost, time cost, and threads for the hashing algorithm.
     |
     */

     'argon' => [
          'memory' => 65536,
          'threads' => 2,
          'time' => 4,
     ],

];

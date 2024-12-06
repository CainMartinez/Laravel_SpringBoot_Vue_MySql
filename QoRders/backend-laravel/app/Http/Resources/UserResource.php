<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
     public function toArray($request)
     {
          return [
               'uuid' => $this->waiter_uuid ?? $this->manager_uuid,
               'firstName' => $this->firstName,
               'lastName' => $this->lastName,
               'email' => $this->email,
               'role' => $request->role,
          ];
     }
}

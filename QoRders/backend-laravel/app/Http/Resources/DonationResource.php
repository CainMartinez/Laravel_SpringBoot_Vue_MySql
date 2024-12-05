<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class DonationResource extends JsonResource
{
     /**
          * Transforma los datos de la donación.
          */
     public function toArray($request)
     {
          return [
               'id' => $this->donation_id,
               'customer_username' => $this->customer_username,
               'quantity' => $this->quantity,
               'ngo_slug' => $this->ngo_slug,
               'created_at' => $this->created_at,
          ];
     }
}

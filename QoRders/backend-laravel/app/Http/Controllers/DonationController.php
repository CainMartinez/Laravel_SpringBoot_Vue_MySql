<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreDonationRequest;
use App\Http\Resources\DonationResource;
use App\Models\Donation;

class DonationController extends Controller
{
     // Método para manejar el POST de donaciones
     public function store(StoreDonationRequest $request)
     {
          // Crear la donación en la base de datos
          $donation = Donation::create($request->validated());

          // Respuesta exitosa usando el Resource
          return (new DonationResource($donation))
               ->additional(['message' => 'Donation created successfully'])
               ->response()
               ->setStatusCode(201);
     }
}

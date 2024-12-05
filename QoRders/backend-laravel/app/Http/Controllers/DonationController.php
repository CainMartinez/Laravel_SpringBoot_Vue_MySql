<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Donation;

class DonationController extends Controller
{
    // Método para manejar el POST de donaciones
     public function store(Request $request)
     {
          // Validar los datos del cuerpo de la solicitud
          $validatedData = $request->validate([
               'customer_username' => 'required|string|max:255',
               'quantity' => 'required|numeric|min:0',
               'ngo_slug' => 'required|string|max:255',
          ]);

          // Crear la donación en la base de datos
          $donation = Donation::create($validatedData);

          // Respuesta exitosa
          return response()->json([
               'message' => 'Donation created successfully',
               'donation' => $donation,
          ], 201);
     }
}

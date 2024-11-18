<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\NGO;

class NGOController extends Controller
{
    public function index()
    {
        return NGO::all(); // Obtener todos los NGOs
    }

    public function show($id)
    {
        return NGO::find($id); // Obtener un NGO por ID
    }

    public function store(Request $request)
    {
        return NGO::create($request->all()); // Crear un nuevo NGO
    }

    public function update(Request $request, $id)
    {
        $ngo = NGO::find($id);
        if ($ngo) {
            $ngo->update($request->all());
            return $ngo;
        }
        return response()->json(['error' => 'NGO not found'], 404);
    }

    public function destroy($id)
    {
        $ngo = NGO::find($id);
        if ($ngo) {
            $ngo->delete();
            return response()->json(['message' => 'NGO deleted successfully']);
        }
        return response()->json(['error' => 'NGO not found'], 404);
    }
}

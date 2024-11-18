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

    public function showBySlug($slug)
    {
        return NGO::where('ngo_slug', $slug)->firstOrFail();
    }

   public function store(Request $request)
    {
        $validated = $request->validate([
            'ngo_name' => 'required|string|max:150',
            'ngo_slug' => 'required|string|unique:ngos,ngo_slug',
            'email' => 'required|email',
        ]);

        return NGO::create($validated);
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

    public function updateBySlug(Request $request, $slug)
    {
        $validated = $request->validate([
            'ngo_name' => 'required|string|max:150',
            'email' => 'required|email',
            // Añade más validaciones según sea necesario
        ]);

        $ngo = NGO::where('ngo_slug', $slug)->firstOrFail();
        $ngo->update($validated);
        return $ngo;
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

    public function deleteBySlug($slug)
    {
        $ngo = NGO::where('ngo_slug', $slug)->firstOrFail();
        $ngo->delete();
        return response()->json(['message' => 'NGO deleted successfully']);
    }
}

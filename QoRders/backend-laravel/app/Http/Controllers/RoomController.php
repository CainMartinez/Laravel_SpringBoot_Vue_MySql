<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Room;

class RoomController extends Controller
{
    public function index()
    {
        return Room::all(); // Obtener todas las salas
    }

    public function show($id)
    {
        return Room::find($id); // Obtener una sala por ID
    }

    public function showBySlug($slug)
    {
        return Room::where('room_slug', $slug)->firstOrFail(); // Obtener una sala por slug
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'room_name' => 'required|string|max:100',
            'room_slug' => 'required|string|unique:rooms,room_slug',
            'description' => 'nullable|string',
            'theme' => 'required|string|max:100',
            'max_capacity' => 'required|integer|min:1',
            'ngo_id' => 'required|integer|exists:ngos,ngo_id',
            'is_active' => 'boolean',
            // Añade más validaciones según sea necesario
        ]);

        return Room::create($validated); // Crear una nueva sala
    }

    public function update(Request $request, $id)
    {
        $room = Room::find($id);
        if ($room) {
            $room->update($request->all());
            return $room;
        }
        return response()->json(['error' => 'Room not found'], 404);
    }

    public function updateBySlug(Request $request, $slug)
    {
        $validated = $request->validate([
            'room_name' => 'string|max:100',
            'description' => 'nullable|string',
            'theme' => 'string|max:100',
            'max_capacity' => 'integer|min:1',
            'ngo_id' => 'integer|exists:ngos,ngo_id',
            'is_active' => 'boolean',
            // Añade más validaciones según sea necesario
        ]);

        $room = Room::where('room_slug', $slug)->firstOrFail();
        $room->update($validated);
        return $room;
    }

    public function destroy($id)
    {
        $room = Room::find($id);
        if ($room) {
            $room->delete();
            return response()->json(['message' => 'Room deleted successfully']);
        }
        return response()->json(['error' => 'Room not found'], 404);
    }

    public function deleteBySlug($slug)
    {
        $room = Room::where('room_slug', $slug)->firstOrFail();
        $room->delete();
        return response()->json(['message' => 'Room deleted successfully']);
    }
}

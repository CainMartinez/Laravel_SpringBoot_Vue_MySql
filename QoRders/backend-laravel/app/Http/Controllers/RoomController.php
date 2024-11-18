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

    public function store(Request $request)
    {
        return Room::create($request->all()); // Crear una nueva sala
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

    public function destroy($id)
    {
        $room = Room::find($id);
        if ($room) {
            $room->delete();
            return response()->json(['message' => 'Room deleted successfully']);
        }
        return response()->json(['error' => 'Room not found'], 404);
    }
}

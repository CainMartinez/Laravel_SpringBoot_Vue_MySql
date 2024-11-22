<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Str;
use App\Models\Room;
use App\Models\Product; 
use App\Models\NGO;     

class RoomController extends Controller
{
    // Obtener todas las salas
    public function index()
    {
        $rooms = Room::all();
        if ($rooms->isEmpty()) {
            return response()->json(['message' => 'No rooms found'], 404);
        }
        return response()->json([
            'message' => 'Rooms retrieved successfully',
            'data' => $rooms
        ], 200);
    }
    // Obtener una sala por ID
    public function show($id)
    {
        $room = Room::find($id);
        if (!$room) {
            return response()->json([
                'message' => 'Room not found',
                'id' => $id
            ], 404);
        }
        return response()->json([
            'message' => 'Room retrieved successfully',
            'data' => $room
        ], 200);
    }
    // Obtener una sala por Slug
    public function showBySlug($slug)
    {
        try {
            $room = Room::where('room_slug', $slug)->firstOrFail();
            return response()->json([
                'message' => 'Room retrieved successfully',
                'data' => $room
            ], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Room not found',
                'slug' => $slug
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    // Crear una nueva sala
    public function store(Request $request)
    {
        try {
            // Validación de datos
            $validated = $request->validate([
                'room_name' => 'required|string|max:100',
                'description' => 'nullable|string',
                'theme' => 'required|string|max:100',
                'max_capacity' => 'required|integer|min:1',
                'ngo_id' => 'required|integer|exists:NGO,ngo_id',
                'is_active' => 'boolean',
            ]);

            // Generar slug usando room_name y un número aleatorio
            $validated['room_slug'] = Str::slug($validated['room_name'], '_') . '_' . rand(100000, 999999);

            // Crear la nueva sala
            $room = Room::create($validated);

            return response()->json([
                'message' => 'Room created successfully',
                'data' => $room
            ], 201); // Estado HTTP 201: Created
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422); // Estado HTTP 422: Unprocessable Entity
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    // Actualizar una sala por id
    public function update(Request $request, $id)
    {
        $room = Room::find($id);
        if ($room) {
            $room->update($request->all());
            return $room;
        }
        return response()->json(['error' => 'Room not found'], 404);
    }
    // Actualizar una sala por slug
    public function updateBySlug(Request $request, $slug)
    {
        try {
            // Validar los datos de la solicitud
            $validated = $request->validate([
                'room_name' => 'string|max:100',
                'description' => 'nullable|string',
                'theme' => 'string|max:100',
                'max_capacity' => 'integer|min:1',
                'ngo_id' => 'integer|exists:ngos,ngo_id',
                'is_active' => 'boolean',
            ]);
            // Buscar la sala por el slug
            $room = Room::where('room_slug', $slug)->firstOrFail();
            // Actualizar la sala con los datos validados
            $room->update($validated);
            return response()->json([
                'message' => 'Room updated successfully',
                'data' => $room
            ], 200);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422); // Estado HTTP 422: Unprocessable Entity
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Room not found',
                'slug' => $slug
            ], 404); // Estado HTTP 404: Not Found
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500); // Estado HTTP 500: Internal Server Error
        }
    }
    // Borrar una sala por id
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
        try {
            // Buscar la sala por el slug
            $room = Room::where('room_slug', $slug)->firstOrFail();
            // Eliminar la sala
            $room->delete();
            return response()->json([
                'message' => 'Room deleted successfully',
                'slug' => $slug
            ], 200); // Estado HTTP 200: OK
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Room not found',
                'slug' => $slug
            ], 404); // Estado HTTP 404: Not Found
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500); // Estado HTTP 500: Internal Server Error
        }
    }
    // Obtener los productos relacionados con el slug de una sala
    public function getProductsByRoomSlug($slug)
    {
        try {
            // Encuentra la sala usando el slug
            $room = Room::where('room_slug', $slug)->firstOrFail();
            // Consulta los productos relacionados con la sala y la ONG correspondiente
            $products = Product::where(function ($query) use ($room) {
                $query->whereHas('ngo', function ($subQuery) use ($room) {
                    $subQuery->where('ngo_id', $room->ngo_id)
                            ->whereColumn('Products.origin', 'NGO.country');
                })
                ->orWhere('origin', 'Generic'); // Añade productos con origin "Generic"
            })->get();
            if ($products->isEmpty()) {
                return response()->json([
                    'message' => 'No products found for the specified room',
                    'room_slug' => $slug
                ], 404); // Estado HTTP 404: No encontrado
            }
            return response()->json([
                'message' => 'Products retrieved successfully',
                'room' => $room->room_name,
                'products' => $products
            ], 200); // Estado HTTP 200: OK
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Room not found',
                'slug' => $slug
            ], 404); // Estado HTTP 404: No encontrado
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500); // Estado HTTP 500: Error interno
        }
    }
}
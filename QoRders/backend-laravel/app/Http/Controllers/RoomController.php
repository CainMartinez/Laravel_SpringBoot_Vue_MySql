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

    // Obtener una sala por Slug
    public function indexBySlug($slug)
    {
        try {
            $room = Room::findBySlugOrFail($slug);

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

    // Crear una nueva salapublic 
    function store(Request $request)
    {
        try {
            // Validación de datos
            $validated = $request->validate([
                'room_name' => 'required|string|max:100',
                'description' => 'nullable|string',
                'max_capacity' => 'required|integer|min:1',
                'image_url' => 'required|string',
                'ngo_id' => 'required|integer|exists:NGO,ngo_id',  // Verifica que la ONG exista
            ]);

            // Verificar si ya existe una sala con el mismo nombre
            $existingRoom = Room::where('room_name', $validated['room_name'])->first();
            if ($existingRoom) {
                return response()->json([
                    'message' => 'A room with this name already exists.',
                ], 409);  // Código 409: Conflict
            }

            // Generar slug usando room_name y un número aleatorio
            $validated['room_slug'] = Room::generateSlug($validated['room_name']);

            // Obtener el país (theme) desde la ONG vinculada
            $ngo = NGO::findOrFail($validated['ngo_id']);
            $validated['theme'] = $ngo->country;

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
            ], 500); // Estado HTTP 500: Internal Server Error
        }
    }

    // Actualizar una sala por slug
    public function update(Request $request, $slug)
    {
        try {
            // Validar los datos de la solicitud
            $validated = $request->validate([
                'room_name' => 'nullable|string|max:100',
                'description' => 'nullable|string',
                'max_capacity' => 'nullable|integer|min:1',
                'image_url' => 'nullable|string',
            ]);

            // Buscar la sala por el slug
            $room = Room::where('room_slug', $slug)->firstOrFail();

            //Comprobar que el nombre nuevo no coincide con el de una sala diferente a la que estamos actualizando
            if ($request->room_name && Room::where('room_name', $request->room_name)->where('room_id', '!=', $room->room_id)->exists()) {
                return response()->json([
                    'message' => 'A room with this name already exists.',
                ], 409);
            }

            // Campos que no pueden ser nulos o vacíos
            $nonNullableFields = ['room_name', 'image_url', 'max_capacity'];

            // Filtrar solo los campos que han cambiado
            $updateData = [];

            foreach ($validated as $key => $value) {
                // Si el valor es nulo o vacío y el campo es obligatorio, lanzar error
                if (in_array($key, $nonNullableFields) && (is_null($value) || $value === '')) {
                    return response()->json([
                        'message' => "The field '$key' cannot be null or empty.",
                    ], 422); // Código 422: Unprocessable Entity
                }

                // Comprobar si el valor ha cambiado
                if ($room->$key !== $value) {
                    $updateData[$key] = $value;

                    // Si cambia el nombre de la sala, actualizar el slug
                    if ($key === 'room_name') {
                        $updateData['room_slug'] = Room::generateSlug($value);
                    }
                }
            }

            // Si no hay cambios, devolver respuesta sin actualizar
            if (empty($updateData)) {
                return response()->json([
                    'message' => 'No changes detected',
                    'data' => $room
                ], 204);
            }

            // Actualizar la sala
            $room->update($updateData);

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

    public function enable($slug)
    {
        try {
            // Buscar la sala por su slug
            $room = Room::where('room_slug', $slug)->firstOrFail();

             // Comprobar si ya está habilitado
            if ($room->is_active) {
                return response()->json([
                    'message' => 'Room is already enabled',
                    'data' => $room
                ], 200); // Estado HTTP 200: OK
            }

            // Actualizar el campo is_active a 1
            $room->update(['is_active' => 1]);

            return response()->json([
                'message' => 'Room has been enabled successfully',
                'data' => $room
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

    public function disable($slug)
    {
        try {
            // Buscar la sala por su slug
            $room = Room::where('room_slug', $slug)->firstOrFail();
            
            // Comprobar si ya está deshabilitado
            if (!$room->is_active) {
                return response()->json([
                    'message' => 'Room is already disabled',
                    'data' => $room
                ], 200); // Estado HTTP 200: OK
            }
            // Actualizar el campo is_active a 0
            $room->update(['is_active' => 0]);

            return response()->json([
                'message' => 'Room has been deactivated successfully',
                'data' => $room
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
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Str;
use App\Models\NGO;

class NGOController extends Controller
{
    public function index()
    {
        try {
            $ngos = NGO::all();

            if ($ngos->isEmpty()) {
                return response()->json([
                    'message' => 'No NGOs found'
                ], 404);
            }

            return response()->json([
                'message' => 'NGOs retrieved successfully',
                'data' => $ngos
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function indexBySlug($slug)
    {
        try {
            $ngo = NGO::where('ngo_slug', $slug)->firstOrFail();

            return response()->json([
                'message' => 'NGO retrieved successfully',
                'data' => $ngo
            ], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'NGO not found',
                'slug' => $slug
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'ngo_name' => 'required|string|max:150',
                'email' => 'required|email',
                'description' => 'required|string',
                'country' => 'required|string|max:100',
                'phone_number' => 'required|string|max:25',
                'website_url' => 'required|string',
                'logo_url' => 'required|string',
                'image_url' => 'required|string',
                'description_img_url' => 'required|string',
            ]);

            // Comprobar si existe una ONG con el mismo nombre o email
            $existingNGO = NGO::where('ngo_name', $validated['ngo_name'])
                        ->orWhere('email', $validated['email'])
                        ->first();

            if ($existingNGO) {
                return response()->json([
                'message' => 'An NGO with this name or email already exists',
                ], 409);
            }

            // Crear el nuevo registro de ONG
            $ngo = new NGO($validated);

            // Generar el slug usando el método del modelo
            $ngo->ngo_slug = NGO::generateSlug($ngo->ngo_name);

            // Guardar la ONG en la base de datos
            $ngo->save();

            return response()->json([
                'message' => 'NGO created successfully',
                'data' => $ngo
            ], 201);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function update(Request $request, $slug)
    {
        try {
            // Validar solo los campos proporcionados en la solicitud
            $validated = $request->validate([
                'ngo_name' => 'nullable|string|max:150',
                'email' => 'nullable|email|max:150',
                'description' => 'nullable|string',
                'phone_number' => 'nullable|string|max:25',
                'website_url' => 'nullable|string',
                'logo_url' => 'nullable|string',
                'image_url' => 'nullable|string',
                'description_img_url' => 'nullable|string',
            ]);

            // Buscar la ONG por slug
            $ngo = NGO::where('ngo_slug', $slug)->firstOrFail();

            // Campos que no pueden ser nulos o vacíos
            $nonNullableFields = ['ngo_name', 'email', 'country'];

            // Filtrar solo los campos que han cambiado
            $updateData = [];

            foreach ($validated as $key => $value) {
                // Si el valor es nulo o vacío y el campo es obligatorio, lanzar error
                if (in_array($key, $nonNullableFields) && (is_null($value) || $value === '')) {
                    return response()->json([
                        'message' => "The field '$key' cannot be null or empty.",
                    ], 422);
                }

                // Comprobar si el valor es diferente al actual
                if ($ngo->$key !== $value) {
                    $updateData[$key] = $value;

                    // Si el nombre cambia, generar un nuevo slug
                    if ($key === 'ngo_name') {
                        $updateData['ngo_slug'] = NGO::generateSlug($value);
                    }
                }
            }

            // Si no hay cambios, responder sin actualizar
            if (empty($updateData)) {
                return response()->json([
                    'message' => 'No changes detected',
                    'data' => $ngo
                ], 204);
            }

            // Realizar la actualización
            $ngo->update($updateData);

            return response()->json([
                'message' => 'NGO updated successfully',
                'data' => $ngo
            ], 200);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'NGO not found',
                'slug' => $slug
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function enable($slug)
    {
        try {
            // Buscar el NGO por su slug
            $ngo = NGO::where('ngo_slug', $slug)->firstOrFail();

            // Comprobar si ya está habilitado
            if ($ngo->is_active) {
                return response()->json([
                    'message' => 'NGO is already enabled',
                    'data' => $ngo
                ], 200); // Estado HTTP 200: OK
            }

            // Actualizar el campo is_active a 1
            $ngo->update(['is_active' => 1]);

            return response()->json([
                'message' => 'NGO has been enabled successfully',
                'data' => $ngo
            ], 200); // Estado HTTP 200: OK
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'NGO not found',
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
            // Buscar el NGO por su slug
            $ngo = NGO::where('ngo_slug', $slug)->firstOrFail();

            // Comprobar si ya está deshabilitado
            if (!$ngo->is_active) {
                return response()->json([
                    'message' => 'NGO is already disabled',
                    'data' => $ngo
                ], 200); // Estado HTTP 200: OK
            }

            // Actualizar el campo is_active a 0
            $ngo->update(['is_active' => 0]);

            return response()->json([
                'message' => 'NGO has been deactivated successfully',
                'data' => $ngo
            ], 200); // Estado HTTP 200: OK
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'NGO not found',
                'slug' => $slug
            ], 404); // Estado HTTP 404: Not Found
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500); // Estado HTTP 500: Internal Server Error
        }
    }
}

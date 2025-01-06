<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Str;
use App\Models\Product;

class ProductController extends Controller
{
    // Listar todos los productos
    public function index()
    {
        try {
            $products = Product::all();

            if ($products->isEmpty()) {
                return response()->json([
                    'message' => 'No products found'
                ], 404);
            }

            return response()->json([
                'message' => 'Products retrieved successfully',
                'data' => $products
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Listar productos filtrados por sala (theme)
    public function indexByRoom($room_theme)
    {
        $products = Product::where('origin', $room_theme)->get();

        if ($products->isEmpty()) {
            return response()->json([
                'message' => "No products found for the room theme: $room_theme"
            ], 404);
        }

        return response()->json([
            'message' => 'Products by room retrieved successfully',
            'room_theme' => $room_theme,
            'data' => $products
        ], 200);
    }

    // Listar un producto por su slug
    public function indexBySlug($slug)
    {
        try {
            $product = Product::where('product_slug', $slug)->firstOrFail();

            return response()->json([
                'message' => 'Product retrieved successfully',
                'data' => $product
            ], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Product not found',
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
            // Validación de datos
            $validated = $request->validate([
                'product_name' => 'required|string|max:150',
                'unit_price' => 'required|numeric|min:0',
                'product_type' => 'required|in:Starter,Main Course,Dessert,Drink',
                'stock' => 'required|integer|min:1',
                'allergens' => 'nullable|string', 
                'image_url' => 'required|string',  
                'description' => 'nullable|string', 
                'origin' => 'required|string|max:100'
            ]);

            // Verificar si ya existe un producto con el mismo nombre en la misma sala (origin)
            $existingProduct = Product::where('product_name', $validated['product_name'])
                                    ->where('origin', $validated['origin'])
                                    ->first();

            if ($existingProduct) {
                return response()->json([
                    'message' => 'A product with this name already exists in the selected room.',
                ], 409);  // Código 409: Conflict
            }

            // Generar el slug usando el nombre del producto
            $validated['product_slug'] = Product::generateSlug($validated['product_name']);

            // Crear el nuevo producto
            $product = Product::create($validated);

            return response()->json([
                'message' => 'Product created successfully',
                'data' => $product
            ], 201); // Estado HTTP 201: Created

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);  // Estado HTTP 422: Unprocessable Entity

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);  // Estado HTTP 500: Internal Server Error
        }
    }

    public function update(Request $request, $slug)
    {
        try {
            // Validar los campos proporcionados en la solicitud
            $validated = $request->validate([
                'product_name' => 'nullable|string|max:150',
                'unit_price' => 'nullable|numeric|min:0',
                'product_type' => 'nullable|in:Starter,Main Course,Dessert,Drink',
                'stock' => 'nullable|integer|min:1',
                'description' => 'nullable|string',
                'allergens' => 'nullable|string',
                'image_url' => 'nullable|string'
            ]);

            // Buscar el producto por el slug
            $product = Product::where('product_slug', $slug)->firstOrFail();

            // Filtrar campos no vacíos o nulos
            $updateData = [];
            foreach ($validated as $key => $value) {
                if (!is_null($value) && $value !== '') {
                    $updateData[$key] = $value;
                }
            }

            // Comprobar si el nombre del producto cambia
            if (isset($updateData['product_name']) && $product->product_name !== $updateData['product_name']) {
                
                // Verificar si ya existe un producto con el mismo nombre y origin
                $existingProduct = Product::where('product_name', $updateData['product_name'])
                                        ->where('origin', $product->origin) // Mantener el mismo origin
                                        ->where('product_id', '!=', $product->product_id) // Excluir el propio producto
                                        ->first();

                if ($existingProduct) {
                    return response()->json([
                        'message' => 'A product with this name already exists in this room.',
                    ], 409);  // Código 409: Conflict
                }

                // Generar un nuevo slug si cambia el nombre
                $updateData['product_slug'] = Product::generateSlug($updateData['product_name']);
            }

            // Actualizar el producto si hay cambios
            if (!empty($updateData)) {
                $product->update($updateData);
                return response()->json([
                    'message' => 'Product updated successfully',
                    'data' => $product
                ], 200);
            }

            return response()->json([
                    'message' => 'No changes detected',
                    'data' => $product
                ], 204);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Product not found',
                'slug' => $slug
            ], 404);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Habilitar producto con su slug
    public function enable($slug)
    {
        try {
            // Buscar el producto por su slug
            $product = Product::where('product_slug', $slug)->firstOrFail();
            
            // Comprobar si ya está habilitado
            if ($product->is_active) {
                return response()->json([
                    'message' => 'Product is already enabled',
                    'data' => $product
                ], 200); // Estado HTTP 200: OK
            }
            // Actualizar el campo is_active a 1
            $product->update(['is_active' => 1]);

            return response()->json([
                'message' => 'Product has been enabled successfully',
                'data' => $product
            ], 200); // Estado HTTP 200: OK
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Product not found',
                'slug' => $slug
            ], 404); // Estado HTTP 404: Not Found
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500); // Estado HTTP 500: Internal Server Error
        }
    }

    // Deshabilitar producto por su slug
    public function disable($slug)
    {
        try {
            // Buscar el producto por su slug
            $product = Product::where('product_slug', $slug)->firstOrFail();

            // Comprobar si ya está deshabilitado
            if (!$product->is_active) {
                return response()->json([
                    'message' => 'Product is already disabled',
                    'data' => $product
                ], 200); // Estado HTTP 200: OK
            }

            // Actualizar el campo is_active a 0
            $product->update(['is_active' => 0]);

            return response()->json([
                'message' => 'Product has been deactivated successfully',
                'data' => $product
            ], 200); // Estado HTTP 200: OK
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Product not found',
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

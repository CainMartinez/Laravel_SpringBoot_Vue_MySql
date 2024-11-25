<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Str;
use App\Models\Product;

class ProductController extends Controller
{
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

    public function show($id)
    {
        try {
            $product = Product::findOrFail($id);

            return response()->json([
                'message' => 'Product retrieved successfully',
                'data' => $product
            ], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Product not found',
                'id' => $id
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function showBySlug($slug)
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
            $validated = $request->validate([
                'product_name' => 'required|string|max:150',
                'unit_price' => 'required|numeric|min:0',
                'product_type' => 'required|in:Starter,Main Course,Dessert,Drink,Other',
                'origin' => 'required|string|max:100',
                'stock' => 'integer|min:0',
                // Añade más validaciones si lo necesitas
            ]);

            // Generar el slug automáticamente
            $validated['product_slug'] = Str::slug($validated['product_name']) . '_' . rand(100000, 999999);

            $product = Product::create($validated);

            return response()->json([
                'message' => 'Product created successfully',
                'data' => $product
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

    public function update(Request $request, $id)
    {
        try {
            $validated = $request->validate([
                'product_name' => 'string|max:150',
                'unit_price' => 'numeric|min:0',
                'product_type' => 'in:Starter,Main Course,Dessert,Drink,Other',
                'origin' => 'string|max:100',
                'stock' => 'integer|min:0',
                // Añade más validaciones si lo necesitas
            ]);

            $product = Product::findOrFail($id);
            $product->update($validated);

            return response()->json([
                'message' => 'Product updated successfully',
                'data' => $product
            ], 200);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Product not found',
                'id' => $id
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function updateBySlug(Request $request, $slug)
    {
        try {
            $validated = $request->validate([
                'product_name' => 'string|max:150',
                'unit_price' => 'numeric|min:0',
                'product_type' => 'in:Starter,Main Course,Dessert,Drink,Other',
                'origin' => 'string|max:100',
                'stock' => 'integer|min:0',
                // Añade más validaciones si lo necesitas
            ]);

            $product = Product::where('product_slug', $slug)->firstOrFail();
            $product->update($validated);

            return response()->json([
                'message' => 'Product updated successfully',
                'data' => $product
            ], 200);
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

    public function destroy($id)
    {
        try {
            $product = Product::findOrFail($id);
            $product->delete();

            return response()->json([
                'message' => 'Product deleted successfully',
                'id' => $id
            ], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'Product not found',
                'id' => $id
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function enableBySlug($slug)
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

    public function unableBySlug($slug)
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

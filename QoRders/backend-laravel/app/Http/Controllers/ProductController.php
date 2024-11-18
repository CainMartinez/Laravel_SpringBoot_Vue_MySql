<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;

class ProductController extends Controller
{
    public function index()
    {
        return Product::all(); // Obtener todos los productos
    }

    public function show($id)
    {
        return Product::find($id); // Obtener un producto por ID
    }

    public function showBySlug($slug)
    {
        return Product::where('product_slug', $slug)->firstOrFail(); // Obtener un producto por slug
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'product_name' => 'required|string|max:150',
            'product_slug' => 'required|string|unique:products,product_slug',
            'unit_price' => 'required|numeric|min:0',
            'product_type' => 'required|in:Starter,Main Course,Dessert,Drink,Other',
            'origin' => 'required|string|max:100',
            'stock' => 'integer|min:0',
            // Añade más validaciones si lo necesitas
        ]);

        return Product::create($validated); // Crear un nuevo producto
    }

    public function update(Request $request, $id)
    {
        $product = Product::find($id);
        if ($product) {
            $product->update($request->all());
            return $product;
        }
        return response()->json(['error' => 'Product not found'], 404);
    }

    public function updateBySlug(Request $request, $slug)
    {
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
        return $product;
    }

    public function destroy($id)
    {
        $product = Product::find($id);
        if ($product) {
            $product->delete();
            return response()->json(['message' => 'Product deleted successfully']);
        }
        return response()->json(['error' => 'Product not found'], 404);
    }

    public function deleteBySlug($slug)
    {
        $product = Product::where('product_slug', $slug)->firstOrFail();
        $product->delete();
        return response()->json(['message' => 'Product deleted successfully']);
    }
}

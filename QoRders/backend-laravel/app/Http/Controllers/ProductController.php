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

    public function store(Request $request)
    {
        return Product::create($request->all()); // Crear un nuevo producto
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

    public function destroy($id)
    {
        $product = Product::find($id);
        if ($product) {
            $product->delete();
            return response()->json(['message' => 'Product deleted successfully']);
        }
        return response()->json(['error' => 'Product not found'], 404);
    }
}

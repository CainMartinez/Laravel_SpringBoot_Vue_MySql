<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
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

    public function show($id)
    {
        try {
            $ngo = NGO::findOrFail($id);

            return response()->json([
                'message' => 'NGO retrieved successfully',
                'data' => $ngo
            ], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'NGO not found',
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
                'ngo_slug' => 'required|string|unique:ngos,ngo_slug',
                'email' => 'required|email',
            ]);

            $ngo = NGO::create($validated);

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

    public function update(Request $request, $id)
    {
        try {
            $validated = $request->validate([
                'ngo_name' => 'string|max:150',
                'email' => 'email',
            ]);

            $ngo = NGO::findOrFail($id);
            $ngo->update($validated);

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
                'ngo_name' => 'string|max:150',
                'email' => 'email',
            ]);

            $ngo = NGO::where('ngo_slug', $slug)->firstOrFail();
            $ngo->update($validated);

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

    public function destroy($id)
    {
        try {
            $ngo = NGO::findOrFail($id);
            $ngo->delete();

            return response()->json([
                'message' => 'NGO deleted successfully',
                'id' => $id
            ], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'message' => 'NGO not found',
                'id' => $id
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function deleteBySlug($slug)
    {
        try {
            $ngo = NGO::where('ngo_slug', $slug)->firstOrFail();
            $ngo->delete();

            return response()->json([
                'message' => 'NGO deleted successfully',
                'slug' => $slug
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
}

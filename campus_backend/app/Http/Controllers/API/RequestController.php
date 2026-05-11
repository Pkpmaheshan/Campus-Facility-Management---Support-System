<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\RequestModel;

class RequestController extends Controller
{
    /**
     * Store Problem or Item Request
     */
public function store(Request $request)
{
    try {
        $validated = $request->validate([
            'user_id' => 'required|integer',
            'type' => 'required|string',
            'title' => 'required|string',
            'description' => 'required|string',
            'location' => 'required|string',
            'priority' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpg,jpeg,png|max:4096', // Added image validation
        ]);

        if ($request->hasFile('image')) {
            $imageName = time() . '_' . $request->file('image')->getClientOriginalName();
            $path = public_path('uploads/problems');
            if (!file_exists($path)) {
                mkdir($path, 0777, true);
            }
            $request->file('image')->move($path, $imageName);
            $validated['image'] = 'uploads/problems/' . $imageName;
        }

        $data = RequestModel::create($validated);

        return response()->json([
            'success' => true,
            'data' => $data
        ], 201);

    } catch (\Exception $e) {
        return response()->json([
            'error' => $e->getMessage()
        ], 500);
    }
}

    /**
     * Get logged-in user's requests
     */
    public function myRequests(Request $request)
    {
        return response()->json(
            RequestModel::where('user_id', $request->user()->id)
                ->latest()
                ->get()
        );
    }

    /**
     * Admin - Get all requests
     */
    public function adminIndex()
    {
        $requests = RequestModel::with('user')->latest()->get();

        return response()->json($requests);
    }
}
<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\LostFoundItem;
use Illuminate\Support\Facades\Storage;

class LostFoundController extends Controller
{
    // ✅ GET ALL POSTS
    public function index(Request $request)
    {
        $query = LostFoundItem::with('user')->latest();

        if ($request->has('search')) {
            $query->where('item_name', 'like', '%' . $request->search . '%');
        }

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        return response()->json($query->get());
    }

    // ✅ ADD POST
    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'type' => 'required|in:lost,found',
                'item_name' => 'required|string|max:255',
                'description' => 'required|string',
                'phone' => 'required|string|max:20',
                'image' => 'nullable|image|max:2048',
            ]);

            $validated['user_id'] = $request->user()->id;

            if ($request->hasFile('image')) {
                $imageName = time() . '_' . $request->file('image')->getClientOriginalName();
                $path = public_path('uploads/lost_found');
                if (!file_exists($path)) {
                    mkdir($path, 0777, true);
                }
                $request->file('image')->move($path, $imageName);
                $validated['image'] = '/uploads/lost_found/' . $imageName;
            }

            $item = LostFoundItem::create($validated);

            return response()->json([
                "message" => "Added successfully",
                "data" => $item
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                "error" => $e->getMessage()
            ], 500);
        }
    }

    // ✅ DELETE POST
    public function destroy(Request $request, $id)
    {
        $item = LostFoundItem::findOrFail($id);

        if ($item->user_id !== $request->user()->id) {
            return response()->json(["error" => "Unauthorized"], 403);
        }

        $item->delete();

        return response()->json([
            "message" => "Deleted"
        ]);
    }
}
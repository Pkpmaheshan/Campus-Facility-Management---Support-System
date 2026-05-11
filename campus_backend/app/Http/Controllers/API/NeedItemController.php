<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\NeedItem;

class NeedItemController extends Controller
{
public function store(Request $request)
{
    $request->validate([
        'user_id' => 'required',
        'items' => 'required',
        'location' => 'required',
    ]);

    $item = \App\Models\NeedItem::create([
        'user_id' => $request->user_id,
        'items' => $request->items,
        'location' => $request->location,
    ]);

    return response()->json([
        'message' => 'Saved successfully',
        'data' => $item
    ], 201);
}
}
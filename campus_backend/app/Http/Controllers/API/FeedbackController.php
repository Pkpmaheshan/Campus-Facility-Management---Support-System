<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Feedback;

class FeedbackController extends Controller
{
    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'user_id' => 'required|integer',
                'message' => 'required|string',
            ]);

            $feedback = Feedback::create([
                'user_id' => $validated['user_id'],
                'message' => $validated['message'],
            ]);

            return response()->json([
                'status' => true,
                'message' => 'Feedback submitted successfully'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
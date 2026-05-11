<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Notification;

class NotificationController extends Controller
{
    /**
     * Get logged-in user's notifications
     */
    public function index(Request $request)
    {
        return Notification::where('user_id', $request->user()->id)
            ->orderByDesc('created_at')
            ->get();
    }

    /**
     * Mark notification as read
     */
    public function markRead($id)
    {
        $notification = Notification::find($id);

        if (!$notification) {
            return response()->json([
                'message' => 'Notification not found'
            ], 404);
        }

        $notification->update([
            'is_read' => true
        ]);

        return response()->json([
            'message' => 'Notification marked as read'
        ], 200);
    }
}

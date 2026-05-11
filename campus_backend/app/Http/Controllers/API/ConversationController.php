<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ConversationController extends Controller
{
    public function start(Request $request)
    {
        $request->validate([
            'lost_found_item_id' => 'required|exists:lost_found_items,id',
            'owner_id' => 'required|exists:users,id',
        ]);

        $conversation = Conversation::firstOrCreate([
            'lost_found_item_id' => $request->lost_found_item_id,
            'user_one_id' => $request->user()->id,
            'user_two_id' => $request->owner_id,
        ]);

        return $conversation;
    }
}

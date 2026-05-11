<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    public function index($conversationId)
    {
        return Message::where('conversation_id', $conversationId)->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'conversation_id' => 'required|exists:conversations,id',
            'message' => 'required|string',
        ]);

        return Message::create([
            'conversation_id' => $request->conversation_id,
            'sender_id' => $request->user()->id,
            'message' => $request->message,
        ]);
    }
}

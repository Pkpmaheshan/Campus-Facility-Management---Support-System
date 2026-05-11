<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Reminder;

class ReminderController extends Controller
{
    /**
     * CREATE REMINDER (PERSONAL ONLY)
     */
    public function store(Request $request)
    {
        // ✅ VALIDATION
        $request->validate([
            'title' => 'required|string',
            'date'  => 'required|date',
            'time'  => 'required',
        ]);

        // 🔒 PERSONAL REMINDER (NO SHARING)
        $reminder = Reminder::create([
            'user_id' => $request->user()->id,
            'title'   => $request->title,
            'date'    => $request->date,
            'time'    => $request->time,
            'is_shared' => false,
        ]);

        return response()->json($reminder, 201);
    }

    /**
     * LIST REMINDERS (USER ONLY)
     * ✅ Student → only their reminders
     * ✅ Lecturer → only their reminders
     */
    public function index(Request $request)
    {
        return Reminder::where('user_id', $request->user()->id)
            ->orderBy('date')
            ->get();
    }

    /**
     * UPDATE REMINDER (OWNER ONLY)
     */
    public function update(Request $request, $id)
    {
        $request->validate([
            'title' => 'required|string',
            'date'  => 'required|date',
            'time'  => 'required',
        ]);

        $reminder = Reminder::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->firstOrFail();

        $reminder->update([
            'title' => $request->title,
            'date'  => $request->date,
            'time'  => $request->time,
        ]);

        return response()->json([
            'message' => 'Reminder updated successfully',
        ]);
    }

    /**
     * DELETE REMINDER (OWNER ONLY)
     */
    public function destroy(Request $request, $id)
    {
        Reminder::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->delete();

        return response()->json([
            'message' => 'Reminder deleted successfully',
        ]);
    }
}

<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Batch;
use App\Models\User;
use Illuminate\Http\Request;

class BatchController extends Controller
{
    /**
     * Get all batches
     */
    public function index()
    {
        return response()->json(Batch::all());
    }

    /**
     * Create a new batch
     */
    public function store(Request $request)
    {
        $request->validate([
            'batch' => 'required|string|unique:batches,batch',
        ]);

        $batch = Batch::create([
            'batch' => $request->batch
        ]);

        return response()->json($batch);
    }

    /**
     * Get students by batch name
     */
    public function students($batchName)
    {
        $students = User::where('batch_number', $batchName)
            ->where('role', 'student')
            ->get();

        return response()->json($students);
    }
}

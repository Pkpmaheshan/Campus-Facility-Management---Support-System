<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\User;

class AdminController extends Controller
{
    /**
     * Get students grouped by batch number
     */
    public function studentsByBatch()
    {
        // get all batches
        $batches = User::select('batch_number')
            ->where('role', 'student')
            ->distinct()
            ->get();

        $result = [];

        foreach ($batches as $batch) {

            $students = User::where('batch_number', $batch->batch_number)
                ->where('role', 'student')
                ->get();

            $result[] = [
                'batch_number' => $batch->batch_number,
                'students' => $students
            ];
        }

        return response()->json($result);
    }

    /**
     * Serve image with CORS headers for Flutter Web
     */
    public function serveImage(\Illuminate\Http\Request $request)
    {
        $path = $request->query('path');
        if (!$path) return response()->json(['error' => 'No path provided'], 400);

        $fullPath = public_path($path);

        if (!\Illuminate\Support\Facades\File::exists($fullPath)) {
            return response()->json(['error' => 'File not found: ' . $path], 404);
        }

        $file = \Illuminate\Support\Facades\File::get($fullPath);
        $type = \Illuminate\Support\Facades\File::mimeType($fullPath);

        return response($file, 200)
            ->header('Content-Type', $type)
            ->header('Access-Control-Allow-Origin', '*');
    }
}
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TimetableController extends Controller
{

    public function add(Request $request)
    {
        DB::table('timetables')->insert([
            'batch' => $request->batch,
            'excel_link' => $request->excel_link,
            'created_at' => now(),
            'updated_at' => now()
        ]);

        return response()->json([
            'message' => 'Timetable added successfully'
        ]);
    }

    public function getBatchTimetable($batch)
    {
        $timetable = DB::table('timetables')
            ->where('batch', $batch)
            ->first();

        return response()->json($timetable);
    }

}

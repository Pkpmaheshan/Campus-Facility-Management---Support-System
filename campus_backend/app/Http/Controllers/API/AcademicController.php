<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Faculty;
use App\Models\Department;
use App\Models\Degree;
use Illuminate\Http\Request;

class AcademicController extends Controller
{
    /**
     * Get all academic data
     */
    public function index()
    {
        try {
            return response()->json([
                'faculties' => Faculty::all(),
                'departments' => Department::all(),
                'degrees' => Degree::all()
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'faculties' => [],
                'departments' => [],
                'degrees' => []
            ]);
        }
    }

    /**
     * Store new Faculty
     */
    public function storeFaculty(Request $request)
    {
        $request->validate(['name' => 'required|string|unique:faculties']);
        $faculty = Faculty::create($request->all());
        return response()->json($faculty);
    }

    /**
     * Store new Department
     */
    public function storeDepartment(Request $request)
    {
        $request->validate(['name' => 'required|string|unique:departments']);
        $dept = Department::create($request->all());
        return response()->json($dept);
    }

    /**
     * Store new Degree
     */
    public function storeDegree(Request $request)
    {
        $request->validate(['name' => 'required|string|unique:degrees']);
        $degree = Degree::create($request->all());
        return response()->json($degree);
    }
}

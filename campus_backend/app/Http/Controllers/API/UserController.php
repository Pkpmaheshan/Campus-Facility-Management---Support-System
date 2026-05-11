<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;

class UserController extends Controller
{
    // Get Students and Lecturers for Admin Panel
    public function getUsers()
{
    $students = \App\Models\User::where('role', 'student')->get();
    $lecturers = \App\Models\User::where('role', 'lecturer')->get();

    return response()->json([
        'students' => $students,
        'lecturers' => $lecturers
    ]);
}

    // ✅ Get Lecturers with Search
    public function searchLecturers(Request $request)
    {
        $query = User::where('role', 'lecturer');

        if ($request->has('search')) {
            $searchTerm = '%' . $request->search . '%';
            $query->where(function($q) use ($searchTerm) {
                $q->where('name', 'like', $searchTerm)
                  ->orWhere('department', 'like', $searchTerm)
                  ->orWhere('faculty', 'like', $searchTerm);
            });
        }

        return response()->json($query->get());
    }

    // Optional: Delete User
    public function deleteUser($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json([
                'message' => 'User not found'
            ], 404);
        }

        $user->delete();

        return response()->json([
            'message' => 'User deleted successfully'
        ]);
    }

    // ✅ Add New User (Student or Lecturer)
    public function storeUser(Request $request)
    {
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => bcrypt($request->password), // Hash the password
            'role' => $request->role,
            'batch_number' => $request->batch_number,
            'campus_id' => $request->campus_id,
            'faculty' => $request->faculty,
            'department' => $request->department,
            'degree' => $request->degree,
        ]);

        return response()->json([
            'message' => 'User created successfully',
            'user' => $user
        ], 201);
    }

    // ✅ Update Student's Batch
    public function updateBatch(Request $request, $id)
    {
        $request->validate(['batch_number' => 'required|string']);
        $user = User::findOrFail($id);
        $user->update(['batch_number' => $request->batch_number]);

        return response()->json([
            'message' => 'Batch updated successfully',
            'user' => $user
        ]);
    }

    // ✅ Update User Profile (Student or Lecturer)
    public function updateUser(Request $request, $id)
    {
        $user = User::findOrFail($id);

        $data = [
            'name' => $request->name,
            'email' => $request->email,
            'role' => $request->role,
            'campus_id' => $request->campus_id,
            'faculty' => $request->faculty,
            'department' => $request->department,
        ];

        // Specific fields for student
        if ($user->role == 'student') {
            $data['degree'] = $request->degree;
            $data['batch_number'] = $request->batch_number;
        }

        // Update password only if provided
        if ($request->has('password') && !empty($request->password)) {
            $data['password'] = bcrypt($request->password);
        }

        $user->update($data);

        return response()->json([
            'message' => 'User updated successfully',
            'user' => $user
        ]);
    }
}
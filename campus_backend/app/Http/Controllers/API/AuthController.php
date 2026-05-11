<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    /**
     * Register User
     */
  public function register(Request $request)
{
    // ✅ Step 1: base validation
    $validated = $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|email|unique:users,email',
        'password' => 'required|min:6',
        'role' => 'required|in:student,lecturer',

        // ✅ allow null for lecturer
        'faculty' => 'nullable|string',
        'department' => 'nullable|string',
        'degree' => 'nullable|string',
        'campus_id' => 'nullable|string',
        'batch_number' => 'nullable|string',
    ]);

    // ✅ Step 2: extra validation ONLY for student
     if ($request->input('role') === 'student'){
        $request->validate([
            'faculty' => 'required|string',
            'department' => 'required|string',
            'degree' => 'required|string',
            'campus_id' => 'required|string',
            'batch_number' => 'required|string',
        ]);
    }

    // ✅ Step 3: create user
    $user = User::create([
        'name' => $validated['name'],
        'email' => $validated['email'],
        'password' => Hash::make($validated['password']),
        'role' => $validated['role'],

        'faculty' => $validated['faculty'] ?? null,
        'department' => $validated['department'] ?? null,
        'degree' => $validated['degree'] ?? null,
        'campus_id' => $validated['campus_id'] ?? null,
        'batch_number' => $validated['batch_number'] ?? null,
    ]);

    $token = $user->createToken('auth_token')->plainTextToken;

    return response()->json([
        'message' => 'Registration successful',
        'user' => $user,
        'token' => $token
    ], 201);
}
    /**
     * Login User
     */
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);

        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json([
                'message' => 'Invalid login credentials'
            ], 401);
        }

        $user = Auth::user();
        $token = $user->createToken('mobile_token')->plainTextToken;

        return response()->json([
            'message' => 'Login successful',
            'user' => $user,
            'token' => $token
        ]);
    }

    /**
     * Logout User
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logged out successfully'
        ]);
    }

    /**
     * Change Password
     */
    public function changePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'new_password' => 'required|min:6|confirmed',
        ]);

        $user = Auth::user();

        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'message' => 'Current password does not match'
            ], 422);
        }

        $user->update([
            'password' => Hash::make($request->new_password)
        ]);

        return response()->json([
            'message' => 'Password changed successfully'
        ]);
    }
}
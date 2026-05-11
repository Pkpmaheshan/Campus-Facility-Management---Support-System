<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\RequestController;
use App\Http\Controllers\API\FeedbackController;
use App\Http\Controllers\API\ReminderController;
use App\Http\Controllers\API\NotificationController;
use App\Http\Controllers\API\LostFoundController;
use App\Http\Controllers\API\ConversationController;
use App\Http\Controllers\API\MessageController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\AdminController;
use App\Models\User;
use App\Models\Batch;
use App\Http\Controllers\TimetableController;
use App\Http\Controllers\API\NeedItemController;
use App\Http\Controllers\API\BatchController;
use App\Http\Controllers\API\AcademicController;


Route::post('/feedback', [FeedbackController::class, 'store']);

Route::post('/need-items', [NeedItemController::class, 'store']);

/*time table */
Route::post('/timetable/add', [TimetableController::class, 'add']);
Route::get('/timetable/{batch}', [TimetableController::class, 'getBatchTimetable']);


Route::get('/lecturers', [UserController::class, 'searchLecturers']);

/* Get all batch groups */
Route::get('/batches', [BatchController::class, 'index']);
Route::post('/create-batch', [BatchController::class, 'store']);

/* Get students by batch */
Route::get('/batch/{batch}/students', [BatchController::class, 'students']);


/*
|--------------------------------------------------------------------------
| 🔓 Public Routes (NO LOGIN REQUIRED)
|--------------------------------------------------------------------------
*/

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

/* ✅ ADMIN ROUTES (TEMPORARY PUBLIC) */
Route::get('/admin/users', [UserController::class, 'getUsers']);
Route::delete('/admin/users/{id}', [UserController::class, 'deleteUser']);
Route::post('/admin/add-user', [UserController::class, 'storeUser']);
Route::put('/admin/users/{id}', [UserController::class, 'updateUser']);
Route::put('/admin/users/{id}/update-batch', [UserController::class, 'updateBatch']);

/* Academic Management */
Route::get('/academic/all', [AcademicController::class, 'index']);
Route::post('/academic/faculty', [AcademicController::class, 'storeFaculty']);
Route::post('/academic/department', [AcademicController::class, 'storeDepartment']);
Route::post('/academic/degree', [AcademicController::class, 'storeDegree']);

Route::get('/requests', [RequestController::class, 'adminIndex']);
Route::get('/admin/students-by-batch', [AdminController::class, 'studentsByBatch']);
Route::get('/get-image', [AdminController::class, 'serveImage']);




/*
|--------------------------------------------------------------------------
| 🔒 Protected Routes (LOGIN REQUIRED)
|--------------------------------------------------------------------------
*/

Route::middleware('auth:sanctum')->group(function () {

    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', function (Request $request) {
        return $request->user();
    });

    Route::post('/requests', [RequestController::class, 'store']);
    Route::get('/my-requests', [RequestController::class, 'myRequests']);


    Route::post('/reminders', [ReminderController::class, 'store']);
    Route::get('/reminders', [ReminderController::class, 'index']);
    Route::put('/reminders/{id}', [ReminderController::class, 'update']);
    Route::delete('/reminders/{id}', [ReminderController::class, 'destroy']);

    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::put('/notifications/{id}/read', [NotificationController::class, 'markRead']);

    Route::get('/lost-found', [LostFoundController::class, 'index']);
    Route::post('/lost-found', [LostFoundController::class, 'store']);
    Route::delete('/lost-found/{id}', [LostFoundController::class, 'destroy']);

    Route::post('/conversations', [ConversationController::class, 'start']);
    Route::get('/messages/{conversationId}', [MessageController::class, 'index']);
    Route::post('/messages', [MessageController::class, 'store']);

    Route::post('/change-password', [AuthController::class, 'changePassword']);

});
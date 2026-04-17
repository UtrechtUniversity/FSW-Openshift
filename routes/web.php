<?php

use App\Http\Controllers\DbHeartbeatController;
use App\Http\Controllers\FileHeartbeatController;
use App\Http\Controllers\MigrationController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    Log::error('Not a real error, but to test logging.');
    if (Auth::check()) {
        Log::info('Index page visited by authenticated user', [
            'user' => Auth::user()->solis_id ?? Auth::id(),
            'role' => Auth::user()->role->name ?? null,
        ]);
    } else {
        Log::info('Index page visited by unauthenticated user');
    }

    return Inertia::render('Welcome');
})->name('home');

Route::middleware(['auth'])->group(function () {
    Route::get('/db-heartbeat', [DbHeartbeatController::class, 'index'])->name('db-heartbeat');
    Route::post('/db-heartbeat', [DbHeartbeatController::class, 'store'])->name('db-heartbeat.add');

    Route::get('/file-heartbeat', [FileHeartbeatController::class, 'index'])->name('file-heartbeat');
    Route::post('/file-heartbeat', [FileHeartbeatController::class, 'store'])->name('file-heartbeat.add');

    // Admin routes - User and Role CRUD
    Route::middleware(['can:isAdmin'])->group(function () {
        Route::resource('users', UserController::class);
        Route::resource('roles', RoleController::class);
        Route::get('migrations', [MigrationController::class, 'index'])->name('migrations.index');
    });
});

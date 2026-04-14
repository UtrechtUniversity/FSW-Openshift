<?php

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Route;

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

    return view('welcome');
})->name('home');

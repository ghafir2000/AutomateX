<?php

use App\Http\Controllers\CategoryController;
use App\Http\Controllers\Dashboard\AuthController;
use App\Http\Controllers\Dashboard\LanguageController;
use App\Http\Controllers\Dashboard\ProductController;
use App\Http\Controllers\TestController;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});


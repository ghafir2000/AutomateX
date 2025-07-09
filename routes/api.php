<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\BarcodeController;
use App\Http\Controllers\API\AuthController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login',[AuthController::class , 'login']);

Route::post('/barcode',[BarcodeController::class , 'store']);
Route::get('/barcode',[BarcodeController::class , 'index']);
Route::put('/barcode/{value}',[BarcodeController::class , 'update']); //the barcode value itself 

// Route::post('/barcode', function (Request $request) {
//     // Access the barcode data sent as form data
//     $barcodeData = $request->input('barcode');
    
//     if ($barcodeData) {
//         // Log it, save to database, etc.
//         \Illuminate\Support\Facades\Log::info('Barcode received: ' . $barcodeData);

//         return response()->json([
//             'message' => 'Barcode received successfully!',
//             'received_barcode' => $barcodeData
//         ], 200);
//     } else {
//         return response()->json(['error' => 'No barcode data received'], 400);
//     }
// });

Route::middleware('auth:sanctum')->group( function () {

  
});


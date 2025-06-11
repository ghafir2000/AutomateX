<?php

namespace App\Http\Controllers\API;

use App\Models\Barcode;
use Illuminate\Http\Request;
use App\Events\BarcodeIndexEvent;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use App\Http\Requests\StoreBarcodeRequest;

class BarcodeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // if (!auth()->check()) {
        //     // You might want to handle this differently, e.g., throw an exception
        //     // or return an unauthenticated response, depending on your API's security.
        //     return $this->response(message: 'Unauthenticated.', code: 401);
        // }
        if (!Auth::attempt(['email' => 'ahmadghafeer@gmail.com', 'password' => 'password'])) { // Provide PLAIN TEXT password
            return $this->response(message: 'The provided credentials are incorrect.', code: 401);
        }

        $barcodes = Barcode::paginate(10);
        

        if (request()->expectsJson()) {
            return $this->response(data: $barcodes);
        }

        return view('index', compact('barcodes'));

    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreBarcodeRequest $request)
    {
         if (!Auth::attempt(['email' => 'ahmadghafeer@gmail.com', 'password' => 'password'])) { // Provide PLAIN TEXT password
            return $this->response(message: 'The provided credentials are incorrect.', code: 401);
        }
        $data = $request->validated();
        try {
            $barcode = Barcode::create($data);
        } catch (\Illuminate\Database\QueryException $e) {
            if ($e->getCode() === '23000') {
                logger()->info('Authenticated ID: ' . Auth()->id());
                return $this->response(message: 'Barcode already exists', code: 409);
            }
            return $this->response(message: 'Failed to store barcode', code: 400);
        }
        
        event(new BarcodeIndexEvent($barcode, Auth()->id()));
        return $this->response(message: 'Barcode received successfully!',code: 200);
    }

    /**
     * Display the specified resource.
     */
    public function show(Barcode $barcode)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Barcode $barcode)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Barcode $barcode)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Barcode $barcode)
    {
        //
    }
}

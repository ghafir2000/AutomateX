<?php

namespace App\Http\Controllers\API;

use App\Models\Barcode;
use Illuminate\Http\Request;
use App\Http\Requests\StoreBarcodeRequest;
use App\Http\Controllers\Controller;

class BarcodeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        if (!auth()->check()) {
            // You might want to handle this differently, e.g., throw an exception
            // or return an unauthenticated response, depending on your API's security.
            return $this->response(message: 'Unauthenticated.', status: 401);
        }
        
        $barcodes = Barcode::all();
        
        event(new BarcodeIndexEvent($barcodes, auth()->id()));

        return $this->response(data: $barcodes);
    }




    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreBarcodeRequest $request)
    {
        $data = $request->validated();
        try {
            $barcode = Barcode::create($data);
        } catch (\Illuminate\Database\QueryException $e) {
            if ($e->getCode() === '23000') {
                return $this->response(message: 'Barcode already exists', code: 409);
            }
            return $this->response(message: 'Failed to store barcode', code: 400);
        }
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

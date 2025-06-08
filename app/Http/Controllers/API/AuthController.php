<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(LoginRequest $request)
    {
        $data = $request->validated();
        $user = User::where('phone', $data['phone'])->first();
        if (!Hash::check($data['password'], $user->password)) {
            return $this->response(message: 'The provided credentials are incorrect.', code: 401);
        }
        $user->token = $user->createToken('auth_token')->plainTextToken;
        return $this->response(UserResource::make($user));
    }
}

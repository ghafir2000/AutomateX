<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class LocalMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $availLocale = config("app.available_locales");
        if($request->header('Accept-Language') && in_array($request->header('Accept-Language'), $availLocale)){
            app()->setLocale($request->header('Accept-Language'));
        }
        if (session()->has('locale') && in_array(session()->get('locale'), $availLocale)) {
            app()->setLocale(session()->get('locale'));
        } else {
            session()->put('locale', 'en');
        }
        return $next($request);
    }
}

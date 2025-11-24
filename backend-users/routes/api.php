<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;

/*
|--------------------------------------------------------------------------
| API Routes - Users Service
|--------------------------------------------------------------------------
*/

Route::get('/health', [UserController::class, 'health']);
Route::get('/users', [UserController::class, 'index']);
Route::get('/users/{id}', [UserController::class, 'show']);

// ⚠️ ENDPOINTS VULNERÁVEIS PARA DEMONSTRAÇÃO DO WAF
// Estes endpoints são intencionalmente vulneráveis para testes educacionais
// NUNCA implemente endpoints assim em produção!
Route::get('/vulnerable/search', [UserController::class, 'search']);
Route::get('/vulnerable/comment', [UserController::class, 'comment']);
Route::get('/vulnerable/file', [UserController::class, 'file']);
Route::get('/vulnerable/ping', [UserController::class, 'ping']);
Route::get('/vulnerable/debug', [UserController::class, 'debug']);

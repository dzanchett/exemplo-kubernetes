<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;

/*
|--------------------------------------------------------------------------
| API Routes - Products Service
|--------------------------------------------------------------------------
*/

Route::get('/health', [ProductController::class, 'health']);
Route::get('/products', [ProductController::class, 'index']);
Route::get('/products/{id}', [ProductController::class, 'show']);

// ⚠️ ENDPOINTS VULNERÁVEIS PARA DEMONSTRAÇÃO DO WAF
// Estes endpoints são intencionalmente vulneráveis para testes educacionais
// NUNCA implemente endpoints assim em produção!
Route::get('/vulnerable/search', [ProductController::class, 'searchProducts']);
Route::post('/vulnerable/import-xml', [ProductController::class, 'importXml']);
Route::get('/vulnerable/fetch', [ProductController::class, 'fetchUrl']);
Route::post('/vulnerable/update', [ProductController::class, 'updateProduct']);
Route::get('/vulnerable/server-info', [ProductController::class, 'serverInfo']);

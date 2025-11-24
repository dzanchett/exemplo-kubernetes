<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;

class ProductController extends Controller
{
    /**
     * Lista todos os produtos
     */
    public function index(): JsonResponse
    {
        $products = [
            [
                'id' => 1,
                'name' => 'Notebook Dell XPS 15',
                'price' => 8999.99,
                'category' => 'Eletr?nicos',
                'stock' => 15
            ],
            [
                'id' => 2,
                'name' => 'Mouse Logitech MX Master 3',
                'price' => 599.90,
                'category' => 'Perif?ricos',
                'stock' => 50
            ],
            [
                'id' => 3,
                'name' => 'Teclado Mec?nico Keychron K2',
                'price' => 799.00,
                'category' => 'Perif?ricos',
                'stock' => 30
            ],
            [
                'id' => 4,
                'name' => 'Monitor LG UltraWide 34"',
                'price' => 2499.99,
                'category' => 'Monitores',
                'stock' => 8
            ],
            [
                'id' => 5,
                'name' => 'Webcam Logitech C920',
                'price' => 499.90,
                'category' => 'Perif?ricos',
                'stock' => 25
            ]
        ];

        return new JsonResponse([
            'success' => true,
            'data' => $products,
            'service' => 'products-api',
            'timestamp' => date('c')
        ]);
    }

    /**
     * Retorna um produto espec?fico
     */
    public function show(int $id): JsonResponse
    {
        $products = [
            1 => [
                'id' => 1,
                'name' => 'Notebook Dell XPS 15',
                'price' => 8999.99,
                'category' => 'Eletr?nicos',
                'stock' => 15,
                'description' => 'Notebook premium com processador Intel i7, 16GB RAM, SSD 512GB',
                'created_at' => '2024-01-10'
            ],
            2 => [
                'id' => 2,
                'name' => 'Mouse Logitech MX Master 3',
                'price' => 599.90,
                'category' => 'Perif?ricos',
                'stock' => 50,
                'description' => 'Mouse ergon?mico wireless com sensor de alta precis?o',
                'created_at' => '2024-01-15'
            ]
        ];

        if (!isset($products[$id])) {
            return new JsonResponse([
                'success' => false,
                'message' => 'Produto não encontrado'
            ], 404);
        }

        return new JsonResponse([
            'success' => true,
            'data' => $products[$id],
            'service' => 'products-api'
        ]);
    }

    /**
     * Endpoint de health check
     */
    public function health(): JsonResponse
    {
        return new JsonResponse([
            'status' => 'healthy',
            'service' => 'products-api',
            'version' => '1.0.0',
            'timestamp' => date('c')
        ]);
    }
}

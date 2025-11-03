<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    /**
     * Lista todos os usu?rios
     */
    public function index(): JsonResponse
    {
        $users = [
            [
                'id' => 1,
                'name' => 'Jo?o Silva',
                'email' => 'joao@example.com',
                'role' => 'Admin'
            ],
            [
                'id' => 2,
                'name' => 'Maria Santos',
                'email' => 'maria@example.com',
                'role' => 'User'
            ],
            [
                'id' => 3,
                'name' => 'Pedro Oliveira',
                'email' => 'pedro@example.com',
                'role' => 'User'
            ],
            [
                'id' => 4,
                'name' => 'Ana Costa',
                'email' => 'ana@example.com',
                'role' => 'Manager'
            ]
        ];

        return response()->json([
            'success' => true,
            'data' => $users,
            'service' => 'users-api',
            'timestamp' => now()->toIso8601String()
        ]);
    }

    /**
     * Retorna um usu?rio espec?fico
     */
    public function show(int $id): JsonResponse
    {
        $users = [
            1 => [
                'id' => 1,
                'name' => 'Jo?o Silva',
                'email' => 'joao@example.com',
                'role' => 'Admin',
                'created_at' => '2024-01-15'
            ],
            2 => [
                'id' => 2,
                'name' => 'Maria Santos',
                'email' => 'maria@example.com',
                'role' => 'User',
                'created_at' => '2024-02-20'
            ]
        ];

        if (!isset($users[$id])) {
            return response()->json([
                'success' => false,
                'message' => 'Usu?rio n?o encontrado'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $users[$id],
            'service' => 'users-api'
        ]);
    }

    /**
     * Endpoint de health check
     */
    public function health(): JsonResponse
    {
        return response()->json([
            'status' => 'healthy',
            'service' => 'users-api',
            'version' => '1.0.0',
            'timestamp' => now()->toIso8601String()
        ]);
    }
}

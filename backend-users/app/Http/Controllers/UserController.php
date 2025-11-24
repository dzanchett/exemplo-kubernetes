<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;

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

        return new JsonResponse([
            'success' => true,
            'data' => $users,
            'service' => 'users-api',
            'timestamp' => date('c')
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
            return new JsonResponse([
                'success' => false,
                'message' => 'Usuário não encontrado'
            ], 404);
        }

        return new JsonResponse([
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
        return new JsonResponse([
            'status' => 'healthy',
            'service' => 'users-api',
            'version' => '1.0.0',
            'timestamp' => date('c')
        ]);
    }
}

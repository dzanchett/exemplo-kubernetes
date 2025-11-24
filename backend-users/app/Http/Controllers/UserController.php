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

    /**
     * ⚠️ VULNERÁVEL: SQL Injection para demonstração educacional
     * Este endpoint é intencionalmente vulnerável para testes do WAF
     * NUNCA use este padrão em produção!
     */
    public function search(): JsonResponse
    {
        $query = $_GET['q'] ?? '';
        
        // VULNERABILIDADE: SQL Injection simulada
        // O WAF deve bloquear tentativas como: ?q=1' OR '1'='1
        if (strpos($query, "'") !== false || 
            strpos(strtoupper($query), "OR") !== false ||
            strpos(strtoupper($query), "UNION") !== false ||
            strpos(strtoupper($query), "SELECT") !== false) {
            return new JsonResponse([
                'success' => false,
                'message' => '⚠️ SQL Injection detectado! Esta requisição seria bloqueada pelo WAF.',
                'vulnerability' => 'SQL Injection',
                'attack_pattern' => $query
            ], 403);
        }

        return new JsonResponse([
            'success' => true,
            'data' => [],
            'query' => $query,
            'message' => 'Busca realizada com sucesso'
        ]);
    }

    /**
     * ⚠️ VULNERÁVEL: XSS (Cross-Site Scripting) para demonstração
     * NUNCA use este padrão em produção!
     */
    public function comment(): JsonResponse
    {
        $comment = $_GET['text'] ?? '';
        
        // VULNERABILIDADE: XSS simulada
        // O WAF deve bloquear: ?text=<script>alert('XSS')</script>
        if (strpos($comment, '<script') !== false || 
            strpos($comment, 'javascript:') !== false ||
            strpos($comment, 'onerror=') !== false ||
            strpos($comment, 'onload=') !== false) {
            return new JsonResponse([
                'success' => false,
                'message' => '⚠️ XSS Attack detectado! Esta requisição seria bloqueada pelo WAF.',
                'vulnerability' => 'Cross-Site Scripting (XSS)',
                'attack_pattern' => $comment
            ], 403);
        }

        return new JsonResponse([
            'success' => true,
            'comment' => $comment,
            'message' => 'Comentário salvo'
        ]);
    }

    /**
     * ⚠️ VULNERÁVEL: Path Traversal para demonstração
     * NUNCA use este padrão em produção!
     */
    public function file(): JsonResponse
    {
        $filename = $_GET['name'] ?? '';
        
        // VULNERABILIDADE: Path Traversal simulada
        // O WAF deve bloquear: ?name=../../etc/passwd
        if (strpos($filename, '..') !== false || 
            strpos($filename, '/etc/') !== false ||
            strpos($filename, '\\') !== false) {
            return new JsonResponse([
                'success' => false,
                'message' => '⚠️ Path Traversal detectado! Esta requisição seria bloqueada pelo WAF.',
                'vulnerability' => 'Path Traversal',
                'attack_pattern' => $filename
            ], 403);
        }

        return new JsonResponse([
            'success' => true,
            'filename' => $filename,
            'message' => 'Arquivo acessado'
        ]);
    }

    /**
     * ⚠️ VULNERÁVEL: Command Injection para demonstração
     * NUNCA use este padrão em produção!
     */
    public function ping(): JsonResponse
    {
        $host = $_GET['host'] ?? 'localhost';
        
        // VULNERABILIDADE: Command Injection simulada
        // O WAF deve bloquear: ?host=localhost; cat /etc/passwd
        if (strpos($host, ';') !== false || 
            strpos($host, '|') !== false ||
            strpos($host, '&') !== false ||
            strpos($host, '`') !== false ||
            strpos($host, '$') !== false) {
            return new JsonResponse([
                'success' => false,
                'message' => '⚠️ Command Injection detectado! Esta requisição seria bloqueada pelo WAF.',
                'vulnerability' => 'Command Injection',
                'attack_pattern' => $host
            ], 403);
        }

        return new JsonResponse([
            'success' => true,
            'host' => $host,
            'status' => 'reachable',
            'message' => 'Ping executado'
        ]);
    }

    /**
     * ⚠️ VULNERÁVEL: Sensitive Data Exposure para demonstração
     * Este endpoint expõe dados sensíveis intencionalmente
     */
    public function debug(): JsonResponse
    {
        return new JsonResponse([
            'success' => true,
            'message' => '⚠️ ATENÇÃO: Este endpoint expõe dados sensíveis!',
            'vulnerability' => 'Sensitive Data Exposure',
            'sensitive_data' => [
                'database_password' => 'super_secret_password_123',
                'api_keys' => [
                    'stripe' => 'sk_test_51HxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxQ',
                    'aws' => 'AKIAIOSFODNN7EXAMPLE'
                ],
                'internal_ips' => ['10.0.0.15', '10.0.0.16'],
                'admin_users' => [
                    ['username' => 'admin', 'password' => 'admin123'],
                    ['username' => 'root', 'password' => 'toor']
                ]
            ],
            'note' => 'Este tipo de endpoint NUNCA deve existir em produção!'
        ]);
    }
}

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

    /**
     * ⚠️ VULNERÁVEL: SQL Injection para demonstração educacional
     * NUNCA use este padrão em produção!
     */
    public function searchProducts(): JsonResponse
    {
        $query = $_GET['q'] ?? '';
        
        // VULNERABILIDADE: SQL Injection simulada
        if (strpos($query, "'") !== false || 
            strpos(strtoupper($query), "OR") !== false ||
            strpos(strtoupper($query), "DROP") !== false) {
            return new JsonResponse([
                'success' => false,
                'message' => '⚠️ SQL Injection detectado! WAF bloqueou esta requisição.',
                'vulnerability' => 'SQL Injection',
                'attack_pattern' => $query
            ], 403);
        }

        return new JsonResponse([
            'success' => true,
            'data' => [],
            'query' => $query
        ]);
    }

    /**
     * ⚠️ VULNERÁVEL: XXE (XML External Entity) para demonstração
     * NUNCA use este padrão em produção!
     */
    public function importXml(): JsonResponse
    {
        $xml = $_POST['xml'] ?? '';
        
        // VULNERABILIDADE: XXE simulada
        if (strpos($xml, '<!ENTITY') !== false || 
            strpos($xml, 'SYSTEM') !== false ||
            strpos($xml, 'file://') !== false) {
            return new JsonResponse([
                'success' => false,
                'message' => '⚠️ XXE Attack detectado! WAF bloqueou esta requisição.',
                'vulnerability' => 'XML External Entity (XXE)',
                'attack_pattern' => substr($xml, 0, 100)
            ], 403);
        }

        return new JsonResponse([
            'success' => true,
            'message' => 'XML processado'
        ]);
    }

    /**
     * ⚠️ VULNERÁVEL: SSRF (Server-Side Request Forgery) para demonstração
     * NUNCA use este padrão em produção!
     */
    public function fetchUrl(): JsonResponse
    {
        $url = $_GET['url'] ?? '';
        
        // VULNERABILIDADE: SSRF simulada
        if (strpos($url, 'localhost') !== false || 
            strpos($url, '127.0.0.1') !== false ||
            strpos($url, '10.') === 0 ||
            strpos($url, '192.168.') === 0 ||
            strpos($url, 'file://') !== false) {
            return new JsonResponse([
                'success' => false,
                'message' => '⚠️ SSRF Attack detectado! WAF bloqueou esta requisição.',
                'vulnerability' => 'Server-Side Request Forgery (SSRF)',
                'attack_pattern' => $url
            ], 403);
        }

        return new JsonResponse([
            'success' => true,
            'url' => $url,
            'message' => 'URL acessada'
        ]);
    }

    /**
     * ⚠️ VULNERÁVEL: Mass Assignment para demonstração
     * NUNCA use este padrão em produção!
     */
    public function updateProduct(): JsonResponse
    {
        $data = $_POST;
        
        // VULNERABILIDADE: Mass Assignment simulada
        if (isset($data['is_admin']) || 
            isset($data['role']) ||
            isset($data['price']) && $data['price'] == 0) {
            return new JsonResponse([
                'success' => false,
                'message' => '⚠️ Mass Assignment detectado! Tentativa de modificar campos protegidos.',
                'vulnerability' => 'Mass Assignment',
                'attempted_fields' => array_keys($data)
            ], 403);
        }

        return new JsonResponse([
            'success' => true,
            'message' => 'Produto atualizado'
        ]);
    }

    /**
     * ⚠️ VULNERÁVEL: Information Disclosure para demonstração
     */
    public function serverInfo(): JsonResponse
    {
        return new JsonResponse([
            'success' => true,
            'message' => '⚠️ Este endpoint expõe informações sensíveis do servidor!',
            'vulnerability' => 'Information Disclosure',
            'server_info' => [
                'php_version' => phpversion(),
                'os' => PHP_OS,
                'server_software' => $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown',
                'document_root' => $_SERVER['DOCUMENT_ROOT'] ?? 'Unknown',
                'server_name' => $_SERVER['SERVER_NAME'] ?? 'Unknown',
                'environment' => [
                    'APP_ENV' => getenv('APP_ENV'),
                    'APP_DEBUG' => getenv('APP_DEBUG'),
                ],
                'loaded_extensions' => get_loaded_extensions()
            ],
            'note' => 'Nunca exponha essas informações em produção!'
        ]);
    }
}

#!/bin/bash

################################################################################
# Script de Teste do WAF BunkerWeb
# Este script simula diversos tipos de ataques para demonstrar
# a proteção do WAF
################################################################################

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# URLs base
USERS_API="http://users-api.local/api"
PRODUCTS_API="http://products-api.local/api"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         Teste de Segurança - BunkerWeb WAF Demo              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Função para testar um ataque
test_attack() {
    local name="$1"
    local url="$2"
    local description="$3"
    
    echo -e "${YELLOW}🔍 Testando: ${name}${NC}"
    echo -e "${BLUE}   URL: ${url}${NC}"
    echo -e "   ${description}"
    echo ""
    
    # Fazer a requisição e capturar o código de status
    HTTP_CODE=$(curl -s -o /tmp/waf_response.txt -w "%{http_code}" "$url" 2>/dev/null || echo "000")
    
    # Verificar o resultado
    if [ "$HTTP_CODE" == "403" ] || [ "$HTTP_CODE" == "406" ] || [ "$HTTP_CODE" == "400" ]; then
        echo -e "${GREEN}   ✅ BLOQUEADO pelo WAF (HTTP $HTTP_CODE)${NC}"
        echo -e "${GREEN}   O WAF está protegendo a aplicação!${NC}"
    elif [ "$HTTP_CODE" == "000" ]; then
        echo -e "${RED}   ❌ ERRO de conexão${NC}"
        echo -e "${RED}   Verifique se o cluster está rodando${NC}"
    else
        echo -e "${RED}   ⚠️  PASSOU (HTTP $HTTP_CODE)${NC}"
        echo -e "${RED}   Este ataque deveria ter sido bloqueado!${NC}"
        cat /tmp/waf_response.txt | jq '.' 2>/dev/null || cat /tmp/waf_response.txt
    fi
    
    echo ""
    echo "─────────────────────────────────────────────────────────────────"
    echo ""
    sleep 1
}

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}                  1. SQL INJECTION ATTACKS                      ${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

test_attack \
    "SQL Injection - OR 1=1" \
    "${USERS_API}/vulnerable/search?q=admin' OR '1'='1" \
    "Tentativa de bypass de autenticação usando OR lógico"

test_attack \
    "SQL Injection - UNION SELECT" \
    "${USERS_API}/vulnerable/search?q=1' UNION SELECT password FROM users--" \
    "Tentativa de extrair dados usando UNION"

test_attack \
    "SQL Injection - DROP TABLE" \
    "${PRODUCTS_API}/vulnerable/search?q='; DROP TABLE products;--" \
    "Tentativa de destruir tabela do banco de dados"

test_attack \
    "SQL Injection - Time-based Blind" \
    "${USERS_API}/vulnerable/search?q=1' AND SLEEP(5)--" \
    "SQL Injection cega baseada em tempo"

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}              2. CROSS-SITE SCRIPTING (XSS)                     ${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

test_attack \
    "XSS - Script Tag" \
    "${USERS_API}/vulnerable/comment?text=<script>alert('XSS')</script>" \
    "Injeção de script malicioso via tag script"

test_attack \
    "XSS - Event Handler" \
    "${USERS_API}/vulnerable/comment?text=<img src=x onerror=alert('XSS')>" \
    "XSS usando manipulador de eventos onerror"

test_attack \
    "XSS - JavaScript Protocol" \
    "${USERS_API}/vulnerable/comment?text=<a href=\"javascript:alert('XSS')\">Click</a>" \
    "XSS usando protocolo javascript:"

test_attack \
    "XSS - Encoded" \
    "${USERS_API}/vulnerable/comment?text=%3Cscript%3Ealert%28%27XSS%27%29%3C%2Fscript%3E" \
    "XSS com caracteres codificados em URL"

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}                  3. PATH TRAVERSAL ATTACKS                     ${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

test_attack \
    "Path Traversal - /etc/passwd" \
    "${USERS_API}/vulnerable/file?name=../../etc/passwd" \
    "Tentativa de acessar arquivo de senhas do sistema"

test_attack \
    "Path Traversal - Windows" \
    "${USERS_API}/vulnerable/file?name=..\\..\\windows\\system32\\config\\sam" \
    "Tentativa de acessar SAM do Windows"

test_attack \
    "Path Traversal - Encoded" \
    "${USERS_API}/vulnerable/file?name=%2e%2e%2f%2e%2e%2fetc%2fpasswd" \
    "Path traversal com encoding"

test_attack \
    "Path Traversal - Null Byte" \
    "${USERS_API}/vulnerable/file?name=../../etc/passwd%00.txt" \
    "Path traversal com null byte injection"

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}                4. COMMAND INJECTION ATTACKS                    ${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

test_attack \
    "Command Injection - Semicolon" \
    "${USERS_API}/vulnerable/ping?host=localhost;cat /etc/passwd" \
    "Tentativa de executar comando adicional usando ;"

test_attack \
    "Command Injection - Pipe" \
    "${USERS_API}/vulnerable/ping?host=localhost|whoami" \
    "Tentativa de encadear comandos usando pipe"

test_attack \
    "Command Injection - Backticks" \
    "${USERS_API}/vulnerable/ping?host=\`whoami\`" \
    "Tentativa de injeção usando backticks"

test_attack \
    "Command Injection - Dollar" \
    "${USERS_API}/vulnerable/ping?host=\$(cat /etc/passwd)" \
    "Tentativa de substituição de comando usando \$"

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}              5. SERVER-SIDE REQUEST FORGERY (SSRF)             ${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

test_attack \
    "SSRF - Localhost" \
    "${PRODUCTS_API}/vulnerable/fetch?url=http://localhost:8080/admin" \
    "Tentativa de acessar serviços internos via localhost"

test_attack \
    "SSRF - Internal IP" \
    "${PRODUCTS_API}/vulnerable/fetch?url=http://192.168.1.1/admin" \
    "Tentativa de acessar rede interna"

test_attack \
    "SSRF - File Protocol" \
    "${PRODUCTS_API}/vulnerable/fetch?url=file:///etc/passwd" \
    "Tentativa de ler arquivos locais usando protocolo file://"

test_attack \
    "SSRF - Cloud Metadata" \
    "${PRODUCTS_API}/vulnerable/fetch?url=http://169.254.169.254/latest/meta-data/" \
    "Tentativa de acessar metadata da cloud (AWS/GCP/Azure)"

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}                    6. OTHER ATTACKS                            ${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

test_attack \
    "XXE - External Entity" \
    "${PRODUCTS_API}/vulnerable/import-xml" \
    "XXE - XML External Entity injection" \
    -X POST \
    -d 'xml=<?xml version="1.0"?><!DOCTYPE foo [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><foo>&xxe;</foo>'

test_attack \
    "User-Agent - Nikto Scanner" \
    "${USERS_API}/health" \
    "Requisição com User-Agent de scanner conhecido" \
    -H "User-Agent: Nikto/2.1.6"

test_attack \
    "User-Agent - SQLMap" \
    "${USERS_API}/health" \
    "Requisição com User-Agent de ferramenta de SQL injection" \
    -H "User-Agent: sqlmap/1.0"

# Limpeza
rm -f /tmp/waf_response.txt

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    Teste Concluído!                           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✅ Testes de segurança finalizados${NC}"
echo -e "${YELLOW}📊 Recomendação: Analise os logs do BunkerWeb para mais detalhes${NC}"
echo ""
echo -e "${BLUE}Para ver os logs do BunkerWeb:${NC}"
echo -e "   kubectl logs -l app=bunkerweb -f"
echo ""


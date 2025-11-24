#!/bin/bash

################################################################################
# Script de Teste do WAF BunkerWeb - Versão para Driver Docker
# Este script usa localhost ao invés de .local domains
################################################################################

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    Teste de Segurança - BunkerWeb WAF (Driver Docker)        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar se WAF_URL está definida
if [ -z "$WAF_URL" ]; then
    echo -e "${RED}❌ Variável WAF_URL não está definida!${NC}"
    echo ""
    echo -e "${YELLOW}📝 Instruções:${NC}"
    echo -e "   1. Em outro terminal, execute: ${GREEN}./waf-expose.sh${NC}"
    echo -e "   2. Anote a URL que aparecer (ex: http://127.0.0.1:51143)"
    echo -e "   3. Defina a variável: ${GREEN}export WAF_URL=http://127.0.0.1:PORTA${NC}"
    echo -e "   4. Execute este script novamente"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ WAF_URL definida: $WAF_URL${NC}"
echo ""

# Testar conectividade
echo -e "${YELLOW}🔍 Testando conectividade com o WAF...${NC}"
if ! curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$WAF_URL/" > /dev/null 2>&1; then
    echo -e "${RED}❌ Não consegui conectar ao WAF!${NC}"
    echo -e "${YELLOW}Certifique-se que ./waf-expose.sh está rodando em outro terminal.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ WAF está acessível!${NC}"
echo ""

# URLs base
USERS_API="$WAF_URL/api"
PRODUCTS_API="$WAF_URL/api"

# Função para testar um ataque
test_attack() {
    local name="$1"
    local url="$2"
    local description="$3"
    local host="$4"  # Host header (users-api.local ou products-api.local)
    
    echo -e "${YELLOW}🔍 Testando: ${name}${NC}"
    echo -e "${BLUE}   URL: ${url}${NC}"
    echo -e "   ${description}"
    echo ""
    
    # Fazer a requisição e capturar o código de status com Header Host correto
    HTTP_CODE=$(curl -s -o /tmp/waf_response.txt -w "%{http_code}" -H "Host: ${host}" "$url" 2>/dev/null || echo "000")
    
    # Verificar o resultado
    if [ "$HTTP_CODE" == "403" ] || [ "$HTTP_CODE" == "406" ] || [ "$HTTP_CODE" == "400" ]; then
        echo -e "${GREEN}   ✅ BLOQUEADO pelo WAF (HTTP $HTTP_CODE)${NC}"
        echo -e "${GREEN}   O WAF está protegendo a aplicação!${NC}"
    elif [ "$HTTP_CODE" == "000" ]; then
        echo -e "${RED}   ❌ ERRO de conexão${NC}"
        echo -e "${RED}   Verifique se waf-expose.sh está rodando${NC}"
    else
        echo -e "${RED}   ⚠️  PASSOU (HTTP $HTTP_CODE)${NC}"
        echo -e "${RED}   Este ataque deveria ter sido bloqueado!${NC}"
        if [ -f /tmp/waf_response.txt ]; then
            cat /tmp/waf_response.txt | head -5
        fi
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
    "Tentativa de bypass de autenticação usando OR lógico" \
    "users-api.local"

test_attack \
    "SQL Injection - UNION SELECT" \
    "${USERS_API}/vulnerable/search?q=1' UNION SELECT password FROM users--" \
    "Tentativa de extrair dados usando UNION" \
    "users-api.local"

test_attack \
    "SQL Injection - DROP TABLE" \
    "${PRODUCTS_API}/vulnerable/search?q='; DROP TABLE products;--" \
    "Tentativa de destruir tabela do banco de dados" \
    "products-api.local"

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}              2. CROSS-SITE SCRIPTING (XSS)                     ${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

test_attack \
    "XSS - Script Tag" \
    "${USERS_API}/vulnerable/comment?text=<script>alert('XSS')</script>" \
    "Injeção de script malicioso via tag script" \
    "users-api.local"

test_attack \
    "XSS - Event Handler" \
    "${USERS_API}/vulnerable/comment?text=<img src=x onerror=alert('XSS')>" \
    "XSS usando manipulador de eventos onerror" \
    "users-api.local"

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}                  3. PATH TRAVERSAL ATTACKS                     ${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

test_attack \
    "Path Traversal - /etc/passwd" \
    "${USERS_API}/vulnerable/file?name=../../etc/passwd" \
    "Tentativa de acessar arquivo de senhas do sistema" \
    "users-api.local"

test_attack \
    "Path Traversal - Encoded" \
    "${USERS_API}/vulnerable/file?name=%2e%2e%2f%2e%2e%2fetc%2fpasswd" \
    "Path traversal com encoding" \
    "users-api.local"

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}                4. COMMAND INJECTION ATTACKS                    ${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

test_attack \
    "Command Injection - Semicolon" \
    "${USERS_API}/vulnerable/ping?host=localhost;cat /etc/passwd" \
    "Tentativa de executar comando adicional usando ;" \
    "users-api.local"

test_attack \
    "Command Injection - Pipe" \
    "${USERS_API}/vulnerable/ping?host=localhost|whoami" \
    "Tentativa de encadear comandos usando pipe" \
    "users-api.local"

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}              5. SERVER-SIDE REQUEST FORGERY (SSRF)             ${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""

test_attack \
    "SSRF - Localhost" \
    "${PRODUCTS_API}/vulnerable/fetch?url=http://localhost:8080/admin" \
    "Tentativa de acessar serviços internos via localhost" \
    "products-api.local"

test_attack \
    "SSRF - Internal IP" \
    "${PRODUCTS_API}/vulnerable/fetch?url=http://192.168.1.1/admin" \
    "Tentativa de acessar rede interna" \
    "products-api.local"

# Limpeza
rm -f /tmp/waf_response.txt

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    Teste Concluído!                           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✅ Testes de segurança finalizados${NC}"
echo -e "${YELLOW}📊 Para ver os logs do BunkerWeb:${NC}"
echo -e "   kubectl logs -l app=bunkerweb -n demo-k8s -f"
echo ""


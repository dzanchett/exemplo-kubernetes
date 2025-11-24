#!/bin/bash

################################################################################
# Demo do WAF BunkerWeb - Para Driver Docker
# Demonstra as vulnerabilidades SEM e COM o WAF
################################################################################

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║       Demonstração WAF BunkerWeb (Driver Docker)            ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}📝 Esta demo tem 2 partes:${NC}"
echo -e "   ${BLUE}Parte 1:${NC} APIs SEM WAF (vulneráveis)"
echo -e "   ${BLUE}Parte 2:${NC} Como o WAF bloquearia os ataques"
echo ""
read -p "Pressione ENTER para continuar..."

################################################################################
# PARTE 1: SEM WAF (Mostra as Vulnerabilidades)
################################################################################

echo ""
echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║         PARTE 1: APIs SEM WAF (VULNERÁVEIS!)                ║${NC}"
echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}Criando port-forwards para as APIs...${NC}"

# Port-forward para users-api
kubectl port-forward -n demo-k8s svc/users-api-service 9091:80 > /dev/null 2>&1 &
PF_USERS=$!

# Port-forward para products-api
kubectl port-forward -n demo-k8s svc/products-api-service 9092:80 > /dev/null 2>&1 &
PF_PRODUCTS=$!

sleep 3
echo -e "${GREEN}✅ Port-forwards criados${NC}"
echo "   Users API: http://localhost:9091"
echo "   Products API: http://localhost:9092"
echo ""

# Função para testar vulnerabilidade
demo_vulnerability() {
    local name="$1"
    local url="$2"
    local description="$3"
    
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}🔓 Testando: ${name}${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}${description}${NC}"
    echo ""
    echo -e "${BLUE}URL: ${url}${NC}"
    echo ""
    
    read -p "Pressione ENTER para executar o ataque..."
    
    HTTP_CODE=$(curl -s -o /tmp/demo_response.txt -w "%{http_code}" "$url" 2>/dev/null || echo "000")
    
    echo ""
    if [ "$HTTP_CODE" == "200" ]; then
        echo -e "${RED}❌ VULNERÁVEL! Ataque PASSOU (HTTP 200)${NC}"
        echo -e "${RED}   A aplicação está exposta!${NC}"
        echo ""
        echo -e "${YELLOW}Resposta:${NC}"
        cat /tmp/demo_response.txt | head -10
    else
        echo -e "${YELLOW}HTTP ${HTTP_CODE}${NC}"
        cat /tmp/demo_response.txt | head -5
    fi
    
    echo ""
    read -p "Pressione ENTER para continuar..."
}

# SQL Injection
demo_vulnerability \
    "SQL Injection" \
    "http://localhost:9091/api/vulnerable/search?q=admin' OR '1'='1" \
    "Tentativa de bypass de autenticação usando SQL Injection"

# XSS
demo_vulnerability \
    "Cross-Site Scripting (XSS)" \
    "http://localhost:9091/api/vulnerable/comment?text=<script>alert('XSS')</script>" \
    "Injeção de script malicioso"

# Path Traversal
demo_vulnerability \
    "Path Traversal" \
    "http://localhost:9091/api/vulnerable/file?name=../../etc/passwd" \
    "Tentativa de acessar arquivos do sistema"

# Command Injection
demo_vulnerability \
    "Command Injection" \
    "http://localhost:9091/api/vulnerable/ping?host=localhost;cat /etc/passwd" \
    "Tentativa de executar comandos no servidor"

# SSRF
demo_vulnerability \
    "Server-Side Request Forgery (SSRF)" \
    "http://localhost:9092/api/vulnerable/fetch?url=http://localhost:8080" \
    "Tentativa de acessar serviços internos"

################################################################################
# PARTE 2: COM WAF (Como seria protegido)
################################################################################

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         PARTE 2: Como o WAF Protege                         ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}O BunkerWeb WAF bloqueia estes ataques usando:${NC}"
echo ""
echo -e "  ${GREEN}✅ ModSecurity + OWASP CRS 3.0${NC}"
echo -e "     - Detecta padrões de SQL Injection"
echo -e "     - Detecta payloads XSS"
echo -e "     - Detecta Path Traversal"
echo -e "     - Detecta Command Injection"
echo ""
echo -e "  ${GREEN}✅ Rate Limiting${NC}"
echo -e "     - Máximo 20 requisições/segundo"
echo -e "     - Proteção contra DDoS"
echo ""
echo -e "  ${GREEN}✅ Bot Detection${NC}"
echo -e "     - Bloqueia scanners (Nikto, SQLMap, etc.)"
echo -e "     - Cookie challenge"
echo ""
echo -e "  ${GREEN}✅ Security Headers${NC}"
echo -e "     - X-Frame-Options"
echo -e "     - Remove headers sensíveis"
echo ""

echo -e "${YELLOW}📊 Resultado Esperado COM WAF:${NC}"
echo ""
echo -e "  🔓 SEM WAF: ${RED}HTTP 200 OK${NC} (vulnerável)"
echo -e "  🛡️  COM WAF: ${GREEN}HTTP 403 Forbidden${NC} (bloqueado)"
echo ""

echo -e "${BLUE}💡 Para ver o WAF funcionando com este projeto:${NC}"
echo ""
echo -e "  ${YELLOW}Opção 1:${NC} Mudar para driver HyperKit"
echo -e "    brew install hyperkit"
echo -e "    minikube delete"
echo -e "    minikube start --driver=hyperkit"
echo -e "    ./scripts/setup.sh"
echo -e "    sudo minikube tunnel"
echo -e "    ./scripts/test-waf.sh"
echo ""
echo -e "  ${YELLOW}Opção 2:${NC} Ver logs do WAF"
echo -e "    kubectl logs -l app=bunkerweb -n demo-k8s -f"
echo ""

# Limpeza
kill $PF_USERS $PF_PRODUCTS 2>/dev/null
rm -f /tmp/demo_response.txt

echo ""
echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                 Demonstração Concluída!                      ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✅ Vulnerabilidades demonstradas${NC}"
echo -e "${YELLOW}🛡️  WAF BunkerWeb protegeria contra todos estes ataques!${NC}"
echo ""


#!/bin/bash

################################################################################
# Simulador de Ataques Avançado
# Este script simula ataques mais sofisticados e automatizados
################################################################################

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# URLs base
USERS_API="http://users-api.local/api"
PRODUCTS_API="http://products-api.local/api"
FRONTEND="http://demo.local"

echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║       Simulador Avançado de Ataques - BunkerWeb WAF Demo         ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Menu de opções
echo -e "${BLUE}Escolha o tipo de simulação:${NC}"
echo ""
echo "  1) 🎯 SQL Injection - Ataque completo"
echo "  2) 🎯 XSS - Cross-Site Scripting massivo"
echo "  3) 🎯 Brute Force - Tentativas de login"
echo "  4) 🎯 DDoS Simulation - Flood de requisições"
echo "  5) 🎯 Web Scanner - Simulação de Nikto/Nmap"
echo "  6) 🎯 OWASP Top 10 - Teste completo"
echo "  7) 🎯 Rate Limiting - Teste de limites"
echo "  8) 🎯 Todos os ataques (demo completa)"
echo ""
read -p "Escolha uma opção [1-8]: " choice

# Função para SQL Injection massivo
sql_injection_attack() {
    echo -e "${YELLOW}🚨 Iniciando ataque SQL Injection...${NC}"
    echo ""
    
    local payloads=(
        "' OR '1'='1"
        "admin' --"
        "' OR 1=1--"
        "' UNION SELECT NULL--"
        "1' AND '1'='1"
        "' OR 'x'='x"
        "1; DROP TABLE users--"
        "' OR ''='"
        "admin'/*"
        "' OR 1=1#"
    )
    
    for payload in "${payloads[@]}"; do
        echo -e "${BLUE}   → Testando: ${payload}${NC}"
        curl -s -w "HTTP %{http_code}\n" \
            "${USERS_API}/vulnerable/search?q=${payload}" \
            -o /dev/null
        sleep 0.5
    done
    
    echo -e "${GREEN}✅ Ataque SQL Injection concluído${NC}"
    echo ""
}

# Função para XSS massivo
xss_attack() {
    echo -e "${YELLOW}🚨 Iniciando ataque XSS...${NC}"
    echo ""
    
    local payloads=(
        "<script>alert('XSS')</script>"
        "<img src=x onerror=alert('XSS')>"
        "<svg onload=alert('XSS')>"
        "<body onload=alert('XSS')>"
        "<iframe src='javascript:alert(1)'>"
        "<input onfocus=alert('XSS') autofocus>"
        "<select onfocus=alert('XSS') autofocus>"
        "<textarea onfocus=alert('XSS') autofocus>"
        "<marquee onstart=alert('XSS')>"
        "<details open ontoggle=alert('XSS')>"
    )
    
    for payload in "${payloads[@]}"; do
        echo -e "${BLUE}   → Testando: ${payload:0:50}...${NC}"
        curl -s -w "HTTP %{http_code}\n" \
            --data-urlencode "text=${payload}" \
            "${USERS_API}/vulnerable/comment" \
            -o /dev/null
        sleep 0.5
    done
    
    echo -e "${GREEN}✅ Ataque XSS concluído${NC}"
    echo ""
}

# Função para Brute Force
brute_force_attack() {
    echo -e "${YELLOW}🚨 Iniciando Brute Force Attack...${NC}"
    echo ""
    
    local usernames=("admin" "root" "user" "test" "administrator")
    local passwords=("123456" "password" "admin" "12345678" "qwerty")
    
    echo -e "${BLUE}   Tentando ${#usernames[@]} usuários com ${#passwords[@]} senhas cada...${NC}"
    echo ""
    
    local attempts=0
    for username in "${usernames[@]}"; do
        for password in "${passwords[@]}"; do
            attempts=$((attempts + 1))
            echo -ne "${BLUE}   → Tentativa $attempts: ${username}:${password}${NC}\r"
            curl -s -X POST \
                -H "Content-Type: application/json" \
                -d "{\"username\":\"${username}\",\"password\":\"${password}\"}" \
                "${USERS_API}/login" \
                -o /dev/null
            sleep 0.2
        done
    done
    
    echo ""
    echo -e "${GREEN}✅ Brute Force concluído: ${attempts} tentativas${NC}"
    echo -e "${YELLOW}   O WAF deve ter detectado e bloqueado este comportamento${NC}"
    echo ""
}

# Função para DDoS Simulation
ddos_attack() {
    echo -e "${YELLOW}🚨 Iniciando DDoS Simulation...${NC}"
    echo ""
    echo -e "${RED}   ⚠️  Enviando 100 requisições em 10 segundos...${NC}"
    echo ""
    
    local count=0
    local blocked=0
    
    for i in {1..100}; do
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${USERS_API}/users")
        
        if [ "$HTTP_CODE" == "429" ] || [ "$HTTP_CODE" == "403" ]; then
            blocked=$((blocked + 1))
        fi
        
        count=$((count + 1))
        echo -ne "${BLUE}   Requisições: $count | Bloqueadas: $blocked${NC}\r"
        sleep 0.1
    done
    
    echo ""
    echo -e "${GREEN}✅ DDoS Simulation concluído${NC}"
    echo -e "${YELLOW}   Total: $count | Bloqueadas pelo WAF: $blocked${NC}"
    echo ""
}

# Função para Web Scanner Simulation
scanner_simulation() {
    echo -e "${YELLOW}🚨 Simulando Web Scanner (Nikto/Nmap)...${NC}"
    echo ""
    
    local common_paths=(
        "/admin"
        "/phpmyadmin"
        "/wp-admin"
        "/.git"
        "/.env"
        "/backup.sql"
        "/config.php"
        "/admin.php"
        "/login.php"
        "/test.php"
    )
    
    echo -e "${BLUE}   Escaneando paths comuns...${NC}"
    echo ""
    
    for path in "${common_paths[@]}"; do
        echo -e "${BLUE}   → Tentando: ${path}${NC}"
        curl -s -w "HTTP %{http_code}\n" \
            -H "User-Agent: Nikto/2.1.6" \
            "${FRONTEND}${path}" \
            -o /dev/null
        sleep 0.3
    done
    
    echo -e "${GREEN}✅ Scanner simulation concluído${NC}"
    echo ""
}

# Função para OWASP Top 10
owasp_top10_test() {
    echo -e "${YELLOW}🚨 Testando OWASP Top 10...${NC}"
    echo ""
    
    echo -e "${BLUE}1️⃣  A01:2021 - Broken Access Control${NC}"
    curl -s "${USERS_API}/vulnerable/debug" | head -n 5
    echo ""
    
    echo -e "${BLUE}2️⃣  A02:2021 - Cryptographic Failures${NC}"
    curl -s "${USERS_API}/users" | grep -o "email.*" | head -n 3
    echo ""
    
    echo -e "${BLUE}3️⃣  A03:2021 - Injection${NC}"
    curl -s "${USERS_API}/vulnerable/search?q=admin'%20OR%20'1'='1" | head -n 5
    echo ""
    
    echo -e "${BLUE}4️⃣  A04:2021 - Insecure Design${NC}"
    curl -s "${PRODUCTS_API}/vulnerable/server-info" | head -n 5
    echo ""
    
    echo -e "${BLUE}5️⃣  A05:2021 - Security Misconfiguration${NC}"
    curl -s -I "${FRONTEND}" | grep -i "server\|x-powered"
    echo ""
    
    echo -e "${BLUE}6️⃣  A06:2021 - Vulnerable Components${NC}"
    curl -s -H "User-Agent: Mozilla/5.0 (Vulnerability Scanner)" "${USERS_API}/health"
    echo ""
    
    echo -e "${BLUE}7️⃣  A07:2021 - Authentication Failures${NC}"
    echo "   (Ver Brute Force test)"
    echo ""
    
    echo -e "${BLUE}8️⃣  A08:2021 - Software and Data Integrity Failures${NC}"
    echo "   (Ver XXE test)"
    echo ""
    
    echo -e "${BLUE}9️⃣  A09:2021 - Security Logging Failures${NC}"
    echo "   Check BunkerWeb logs"
    echo ""
    
    echo -e "${BLUE}🔟 A10:2021 - Server-Side Request Forgery${NC}"
    curl -s "${PRODUCTS_API}/vulnerable/fetch?url=http://localhost" | head -n 5
    echo ""
    
    echo -e "${GREEN}✅ OWASP Top 10 test concluído${NC}"
    echo ""
}

# Função para Rate Limiting test
rate_limit_test() {
    echo -e "${YELLOW}🚨 Testando Rate Limiting...${NC}"
    echo ""
    echo -e "${BLUE}   Enviando 50 requisições rápidas...${NC}"
    echo ""
    
    local success=0
    local limited=0
    
    for i in {1..50}; do
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${USERS_API}/users")
        
        if [ "$HTTP_CODE" == "200" ]; then
            success=$((success + 1))
        elif [ "$HTTP_CODE" == "429" ]; then
            limited=$((limited + 1))
        fi
        
        echo -ne "${BLUE}   Requisições: $i | Sucesso: $success | Rate Limited: $limited${NC}\r"
    done
    
    echo ""
    echo -e "${GREEN}✅ Rate Limiting test concluído${NC}"
    echo -e "${YELLOW}   Sucesso: $success | Bloqueadas: $limited${NC}"
    echo ""
}

# Executar baseado na escolha
case $choice in
    1)
        sql_injection_attack
        ;;
    2)
        xss_attack
        ;;
    3)
        brute_force_attack
        ;;
    4)
        ddos_attack
        ;;
    5)
        scanner_simulation
        ;;
    6)
        owasp_top10_test
        ;;
    7)
        rate_limit_test
        ;;
    8)
        echo -e "${RED}🔥 EXECUTANDO TODOS OS ATAQUES! 🔥${NC}"
        echo ""
        sql_injection_attack
        sleep 2
        xss_attack
        sleep 2
        brute_force_attack
        sleep 2
        ddos_attack
        sleep 2
        scanner_simulation
        sleep 2
        owasp_top10_test
        sleep 2
        rate_limit_test
        ;;
    *)
        echo -e "${RED}Opção inválida!${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                    Simulação Concluída!                          ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}📊 Para ver as estatísticas do WAF:${NC}"
echo -e "   kubectl logs -l app=bunkerweb --tail=100"
echo ""
echo -e "${YELLOW}📈 Para monitorar em tempo real:${NC}"
echo -e "   kubectl logs -l app=bunkerweb -f"
echo ""


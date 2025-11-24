#!/bin/bash

###############################################################################
# Script de Gerenciamento do BunkerWeb WAF
# Gerencia e monitora o Web Application Firewall
###############################################################################

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}╔═════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║        Gerenciamento do BunkerWeb WAF                  ║${NC}"
echo -e "${PURPLE}╚═════════════════════════════════════════════════════════╝${NC}"
echo ""

# Menu
echo -e "${BLUE}Escolha uma opção:${NC}"
echo ""
echo "  1) 📊 Status do WAF"
echo "  2) 📜 Ver logs (tempo real)"
echo "  3) 📈 Estatísticas de bloqueios"
echo "  4) 🔄 Reiniciar WAF"
echo "  5) 🛑 Desabilitar WAF (usar ingress direto)"
echo "  6) ✅ Habilitar WAF (usar ingress com WAF)"
echo "  7) ⚙️  Configuração atual"
echo "  8) 🧪 Testar proteções"
echo "  9) 🚪 Sair"
echo ""
read -p "Opção [1-9]: " choice

case $choice in
    1)
        # Status do WAF
        echo -e "\n${YELLOW}📊 Status do BunkerWeb WAF:${NC}"
        echo ""
        kubectl get pods -l app=bunkerweb -n demo-k8s -o wide
        echo ""
        kubectl get svc bunkerweb-service -n demo-k8s
        echo ""
        echo -e "${BLUE}Deployment Info:${NC}"
        kubectl describe deployment bunkerweb -n demo-k8s | grep -A 5 "Replicas:"
        ;;
        
    2)
        # Ver logs em tempo real
        echo -e "\n${YELLOW}📜 Logs do BunkerWeb (Ctrl+C para sair):${NC}"
        echo ""
        kubectl logs -l app=bunkerweb -n demo-k8s -f --tail=50
        ;;
        
    3)
        # Estatísticas
        echo -e "\n${YELLOW}📈 Estatísticas de Bloqueios:${NC}"
        echo ""
        
        LOGS=$(kubectl logs -l app=bunkerweb -n demo-k8s --tail=1000)
        
        echo -e "${BLUE}Total de requisições bloqueadas (403):${NC}"
        echo "$LOGS" | grep -c " 403 " || echo "0"
        
        echo -e "\n${BLUE}Total de requisições bloqueadas (406):${NC}"
        echo "$LOGS" | grep -c " 406 " || echo "0"
        
        echo -e "\n${BLUE}Rate Limited (429):${NC}"
        echo "$LOGS" | grep -c " 429 " || echo "0"
        
        echo -e "\n${BLUE}Top 5 IPs bloqueados:${NC}"
        echo "$LOGS" | grep " 403 \| 406 " | awk '{print $1}' | sort | uniq -c | sort -rn | head -5
        
        echo -e "\n${BLUE}Tipos de ataques detectados:${NC}"
        echo "$LOGS" | grep -i "modsecurity\|blocked\|attack" | head -10
        ;;
        
    4)
        # Reiniciar WAF
        echo -e "\n${YELLOW}🔄 Reiniciando BunkerWeb WAF...${NC}"
        kubectl rollout restart deployment/bunkerweb -n demo-k8s
        echo -e "${GREEN}✅ WAF reiniciado${NC}"
        echo ""
        kubectl rollout status deployment/bunkerweb -n demo-k8s
        ;;
        
    5)
        # Desabilitar WAF
        echo -e "\n${RED}🛑 Desabilitando WAF (aplicando ingress direto)...${NC}"
        echo -e "${YELLOW}⚠️  ATENÇÃO: Suas aplicações ficarão desprotegidas!${NC}"
        read -p "Tem certeza? (s/N): " confirm
        if [ "$confirm" == "s" ] || [ "$confirm" == "S" ]; then
            kubectl apply -f ../k8s/ingress.yaml -n demo-k8s
            echo -e "${GREEN}✅ Ingress direto aplicado (sem WAF)${NC}"
        else
            echo -e "${BLUE}Operação cancelada${NC}"
        fi
        ;;
        
    6)
        # Habilitar WAF
        echo -e "\n${GREEN}✅ Habilitando WAF (aplicando ingress com proteção)...${NC}"
        kubectl apply -f ../k8s/ingress-with-bunkerweb.yaml -n demo-k8s
        echo -e "${GREEN}✅ Ingress com WAF aplicado${NC}"
        echo -e "${BLUE}Suas aplicações agora estão protegidas!${NC}"
        ;;
        
    7)
        # Configuração atual
        echo -e "\n${YELLOW}⚙️  Configuração Atual do BunkerWeb:${NC}"
        echo ""
        kubectl describe deployment bunkerweb -n demo-k8s | grep -A 50 "Environment:"
        ;;
        
    8)
        # Testar proteções
        echo -e "\n${YELLOW}🧪 Executando testes de segurança...${NC}"
        echo ""
        if [ -f "./test-waf.sh" ]; then
            ./test-waf.sh
        else
            echo -e "${RED}Erro: Script test-waf.sh não encontrado${NC}"
        fi
        ;;
        
    9)
        # Sair
        echo -e "\n${GREEN}👋 Até logo!${NC}"
        exit 0
        ;;
        
    *)
        echo -e "${RED}Opção inválida!${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${PURPLE}╔═════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                    Concluído!                          ║${NC}"
echo -e "${PURPLE}╚═════════════════════════════════════════════════════════╝${NC}"
echo ""


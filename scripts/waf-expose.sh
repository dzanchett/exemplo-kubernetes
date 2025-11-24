#!/bin/bash

###############################################################################
# Script para expor o BunkerWeb WAF no macOS com driver Docker
# Este script cria um túnel e expõe o WAF em localhost
###############################################################################

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Expor BunkerWeb WAF (Driver Docker)            ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}📝 IMPORTANTE:${NC}"
echo -e "   Este script cria um túnel e expõe o WAF em ${GREEN}localhost${NC}"
echo -e "   Deixe este terminal ABERTO durante os testes!"
echo ""

echo -e "${BLUE}Verificando Minikube...${NC}"
if ! minikube status > /dev/null 2>&1; then
    echo -e "${RED}❌ Minikube não está rodando!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Minikube está rodando${NC}"
echo ""

echo -e "${BLUE}Verificando BunkerWeb...${NC}"
if ! kubectl get svc bunkerweb-service -n demo-k8s > /dev/null 2>&1; then
    echo -e "${RED}❌ BunkerWeb não está deployed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ BunkerWeb está deployed${NC}"
echo ""

echo -e "${YELLOW}🌐 Expondo BunkerWeb WAF...${NC}"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}O WAF será exposto em localhost!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Aguarde a URL aparecer abaixo...${NC}"
echo ""

# Executar minikube service
minikube service bunkerweb-service -n demo-k8s


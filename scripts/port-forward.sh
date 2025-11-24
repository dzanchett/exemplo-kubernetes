#!/bin/bash

###############################################################################
# Script para criar port-forward e acessar serviços via localhost
###############################################################################

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

NAMESPACE="demo-k8s"

echo -e "${BLUE}"
echo "═══════════════════════════════════════════════════════════════"
echo "║   Port Forward - Acesso Local aos Serviços                ║"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

# Verificar se o namespace existe
if ! kubectl get namespace $NAMESPACE &> /dev/null; then
    echo -e "${RED}❌ Namespace $NAMESPACE não encontrado. Execute ./setup.sh primeiro.${NC}"
    exit 1
fi

# Verificar se os serviços existem
if ! kubectl get service -n $NAMESPACE &> /dev/null; then
    echo -e "${RED}❌ Serviços não encontrados no namespace $NAMESPACE.${NC}"
    exit 1
fi

echo -e "${YELLOW}🚀 Criando port-forwards...${NC}"
echo -e "${BLUE}Os serviços estarão disponíveis em:${NC}"
echo ""
echo -e "${GREEN}✅ Frontend:       http://localhost:8080${NC}"
echo -e "${GREEN}   Users API:      http://localhost:8081/api/users${NC}"
echo -e "${GREEN}   Products API:   http://localhost:8082/api/products${NC}"
echo ""
echo -e "${YELLOW}📱 O frontend em http://localhost:8080 está pronto para usar!${NC}"
echo -e "${BLUE}   O frontend acessa as APIs internamente via proxy do Nginx${NC}"
echo ""
echo -e "${YELLOW}⏸  Pressione Ctrl+C para parar os port-forwards${NC}"
echo ""

# Criar port-forwards em background
kubectl port-forward -n $NAMESPACE service/frontend-service 8080:80 &
FRONTEND_PID=$!

kubectl port-forward -n $NAMESPACE service/users-api-service 8081:80 &
USERS_PID=$!

kubectl port-forward -n $NAMESPACE service/products-api-service 8082:80 &
PRODUCTS_PID=$!

# Função para limpar processos ao sair
cleanup() {
    echo -e "\n${YELLOW}🛑 Parando port-forwards...${NC}"
    kill $FRONTEND_PID $USERS_PID $PRODUCTS_PID 2>/dev/null || true
    echo -e "${GREEN}✅ Port-forwards parados${NC}"
    exit 0
}

trap cleanup SIGINT SIGTERM

# Aguardar processos
wait


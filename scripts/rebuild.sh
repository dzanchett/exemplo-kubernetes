#!/bin/bash

###############################################################################
# Script para rebuildar as imagens e atualizar os deployments
###############################################################################

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "??????????????????????????????????????????????????????????????"
echo "?          Rebuild de Imagens e Update Deployments          ?"
echo "??????????????????????????????????????????????????????????????"
echo -e "${NC}"

# Configurar Docker para usar o daemon do Minikube
echo -e "${YELLOW}?? Configurando Docker para usar o daemon do Minikube...${NC}"
eval $(minikube docker-env)

echo -e "${YELLOW}Qual aplicação deseja rebuildar?${NC}"
echo -e "${GREEN}1)${NC} Users API"
echo -e "${GREEN}2)${NC} Products API"
echo -e "${GREEN}3)${NC} Frontend"
echo -e "${GREEN}4)${NC} BunkerWeb WAF (restart apenas)"
echo -e "${GREEN}5)${NC} Todas"
echo ""
read -p "Opção: " option

rebuild_users() {
    echo -e "\n${BLUE}🔨 Rebuilding Users API...${NC}"
    docker build -t users-api:latest ../backend-users/
    kubectl rollout restart deployment/users-api -n demo-k8s
    echo -e "${GREEN}✅ Users API atualizado${NC}"
}

rebuild_products() {
    echo -e "\n${BLUE}🔨 Rebuilding Products API...${NC}"
    docker build -t products-api:latest ../backend-products/
    kubectl rollout restart deployment/products-api -n demo-k8s
    echo -e "${GREEN}✅ Products API atualizado${NC}"
}

rebuild_frontend() {
    echo -e "\n${BLUE}🔨 Rebuilding Frontend...${NC}"
    docker build -t frontend:latest ../frontend/
    kubectl rollout restart deployment/frontend -n demo-k8s
    echo -e "${GREEN}✅ Frontend atualizado${NC}"
}

restart_waf() {
    echo -e "\n${BLUE}🛡️  Restarting BunkerWeb WAF...${NC}"
    kubectl rollout restart deployment/bunkerweb -n demo-k8s
    echo -e "${GREEN}✅ BunkerWeb WAF reiniciado${NC}"
}

case $option in
    1)
        rebuild_users
        ;;
    2)
        rebuild_products
        ;;
    3)
        rebuild_frontend
        ;;
    4)
        restart_waf
        ;;
    5)
        rebuild_users
        rebuild_products
        rebuild_frontend
        restart_waf
        ;;
    *)
        echo -e "${RED}Opção inválida${NC}"
        exit 1
        ;;
esac

echo -e "\n${YELLOW}⏳ Aguardando novos pods ficarem prontos...${NC}"
kubectl rollout status deployment/users-api -n demo-k8s 2>/dev/null &
kubectl rollout status deployment/products-api -n demo-k8s 2>/dev/null &
kubectl rollout status deployment/frontend -n demo-k8s 2>/dev/null &
kubectl rollout status deployment/bunkerweb -n demo-k8s 2>/dev/null &
wait

echo -e "\n${GREEN}"
echo "??????????????????????????????????????????????????????????????"
echo "?           ? Rebuild Conclu?do com Sucesso!                ?"
echo "??????????????????????????????????????????????????????????????"
echo -e "${NC}"

echo -e "\n${YELLOW}📊 Status dos Pods:${NC}"
kubectl get pods -n demo-k8s

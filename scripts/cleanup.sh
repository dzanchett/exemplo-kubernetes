#!/bin/bash

###############################################################################
# Script para limpar todos os recursos do cluster
###############################################################################

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}"
echo "??????????????????????????????????????????????????????????????"
echo "?           Limpeza do Cluster Kubernetes - Minikube        ?"
echo "??????????????????????????????????????????????????????????????"
echo -e "${NC}"

echo -e "${YELLOW}??  Este script ir? remover TODOS os recursos do cluster!${NC}"
read -p "Deseja continuar? (s/N): " confirm

if [[ ! $confirm =~ ^[Ss]$ ]]; then
    echo -e "${GREEN}Opera??o cancelada.${NC}"
    exit 0
fi

echo -e "\n${YELLOW}???  Removendo recursos do Kubernetes...${NC}"

# Remover Ingress
echo -e "${BLUE}Removendo Ingress...${NC}"
kubectl delete -f ../k8s/ingress.yaml 2>/dev/null || true

# Remover Deployments e Services
echo -e "${BLUE}Removendo Frontend...${NC}"
kubectl delete -f ../k8s/frontend-deployment.yaml 2>/dev/null || true

echo -e "${BLUE}Removendo Products API...${NC}"
kubectl delete -f ../k8s/products-api-deployment.yaml 2>/dev/null || true

echo -e "${BLUE}Removendo Users API...${NC}"
kubectl delete -f ../k8s/users-api-deployment.yaml 2>/dev/null || true

# Remover ConfigMap
echo -e "${BLUE}Removendo ConfigMap...${NC}"
kubectl delete -f ../k8s/configmap.yaml 2>/dev/null || true

# Remover Namespace
echo -e "${BLUE}Removendo Namespace...${NC}"
kubectl delete -f ../k8s/namespace.yaml 2>/dev/null || true

# Aguardar a limpeza
echo -e "\n${YELLOW}? Aguardando finaliza??o da limpeza...${NC}"
sleep 5

echo -e "\n${YELLOW}Deseja tamb?m parar o Minikube? (s/N): ${NC}"
read -p "" stop_minikube

if [[ $stop_minikube =~ ^[Ss]$ ]]; then
    echo -e "${YELLOW}?? Parando Minikube...${NC}"
    minikube stop
    echo -e "${GREEN}? Minikube parado${NC}"
fi

echo -e "\n${YELLOW}Deseja deletar completamente o cluster Minikube? (s/N): ${NC}"
read -p "" delete_minikube

if [[ $delete_minikube =~ ^[Ss]$ ]]; then
    echo -e "${RED}??  ATEN??O: Isso ir? deletar TUDO do Minikube!${NC}"
    read -p "Tem certeza? (s/N): " confirm_delete
    
    if [[ $confirm_delete =~ ^[Ss]$ ]]; then
        echo -e "${YELLOW}???  Deletando Minikube...${NC}"
        minikube delete
        echo -e "${GREEN}? Minikube deletado completamente${NC}"
    fi
fi

echo -e "\n${GREEN}"
echo "??????????????????????????????????????????????????????????????"
echo "?              ? Limpeza Conclu?da com Sucesso!             ?"
echo "??????????????????????????????????????????????????????????????"
echo -e "${NC}"

echo -e "${YELLOW}?? Lembre-se de remover as entradas do /etc/hosts:${NC}"
echo -e "${BLUE}sudo sed -i '' '/demo.local/d' /etc/hosts${NC}"
echo -e "${BLUE}sudo sed -i '' '/users-api.local/d' /etc/hosts${NC}"
echo -e "${BLUE}sudo sed -i '' '/products-api.local/d' /etc/hosts${NC}"
echo ""

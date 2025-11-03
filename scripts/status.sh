#!/bin/bash

###############################################################################
# Script para verificar o status do cluster
###############################################################################

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "??????????????????????????????????????????????????????????????"
echo "?          Status do Cluster Kubernetes - Minikube          ?"
echo "??????????????????????????????????????????????????????????????"
echo -e "${NC}"

# Status do Minikube
echo -e "${YELLOW}?? Status do Minikube:${NC}"
minikube status
echo ""

# IP do Minikube
echo -e "${YELLOW}?? IP do Minikube:${NC}"
echo -e "${GREEN}$(minikube ip)${NC}"
echo ""

# Nodes
echo -e "${YELLOW}???  Nodes:${NC}"
kubectl get nodes
echo ""

# Pods
echo -e "${YELLOW}?? Pods:${NC}"
kubectl get pods -o wide
echo ""

# Services
echo -e "${YELLOW}?? Services:${NC}"
kubectl get services
echo ""

# Ingress
echo -e "${YELLOW}?? Ingress:${NC}"
kubectl get ingress
echo ""

# Deployments
echo -e "${YELLOW}?? Deployments:${NC}"
kubectl get deployments
echo ""

# Recursos do cluster
echo -e "${YELLOW}?? Uso de Recursos:${NC}"
kubectl top nodes 2>/dev/null || echo "Metrics server ainda n?o est? pronto"
kubectl top pods 2>/dev/null || echo "Aguardando m?tricas dos pods..."
echo ""

# URLs
echo -e "${YELLOW}?? URLs de Acesso:${NC}"
MINIKUBE_IP=$(minikube ip)
echo -e "${GREEN}Frontend:      http://demo.local (${MINIKUBE_IP})${NC}"
echo -e "${GREEN}Users API:     http://users-api.local/api/users${NC}"
echo -e "${GREEN}Products API:  http://products-api.local/api/products${NC}"
echo ""

# Health Check
echo -e "${YELLOW}?? Health Checks:${NC}"
echo -e "Users API Health: ${GREEN}$(curl -s http://users-api.local/api/health 2>/dev/null | grep -o '"status":"[^"]*"' || echo 'N?o dispon?vel')${NC}"
echo -e "Products API Health: ${GREEN}$(curl -s http://products-api.local/api/health 2>/dev/null | grep -o '"status":"[^"]*"' || echo 'N?o dispon?vel')${NC}"
echo ""

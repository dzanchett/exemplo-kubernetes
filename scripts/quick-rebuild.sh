#!/bin/bash

###############################################################################
# Script para Rebuild e Redeploy Rápido das APIs
###############################################################################

set -e

# Adicionar ~/bin ao PATH se minikube estiver instalado lá
if [ -f ~/bin/minikube ]; then
    export PATH="$HOME/bin:$PATH"
fi

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔨 Rebuild e Redeploy Rápido${NC}\n"

# Configurar Docker para usar o daemon do Minikube
echo -e "${YELLOW}🔧 Configurando Docker...${NC}"
eval $(minikube docker-env)
export DOCKER_BUILDKIT=0

# Rebuild Users API
echo -e "\n${BLUE}📦 Rebuilding Users API...${NC}"
docker build -t users-api:latest ../backend-users/

# Rebuild Products API
echo -e "\n${BLUE}📦 Rebuilding Products API...${NC}"
docker build -t products-api:latest ../backend-products/

# Redeploy
echo -e "\n${YELLOW}🚀 Redeploying...${NC}"
kubectl delete deployment users-api products-api -n demo-k8s --ignore-not-found=true
sleep 2
kubectl apply -f ../k8s/users-api-deployment.yaml -n demo-k8s
kubectl apply -f ../k8s/products-api-deployment.yaml -n demo-k8s

# Wait for pods
echo -e "\n${YELLOW}⏳ Aguardando pods ficarem prontos...${NC}"
kubectl wait --for=condition=ready pod -l app=users-api -n demo-k8s --timeout=120s || true
kubectl wait --for=condition=ready pod -l app=products-api -n demo-k8s --timeout=120s || true

# Status
echo -e "\n${GREEN}✅ Deploy concluído!${NC}\n"
kubectl get pods -n demo-k8s

echo -e "\n${BLUE}📋 Testando endpoints:${NC}"
echo -e "${YELLOW}Execute: kubectl port-forward -n demo-k8s service/users-api-service 8081:80${NC}"
echo -e "${YELLOW}E acesse: curl http://localhost:8081/api/health${NC}\n"


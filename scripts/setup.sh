#!/bin/bash

###############################################################################
# Script de Setup do Cluster Kubernetes com Minikube
# Demonstra??o para aula - Sistema de Microservi?os
###############################################################################

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "??????????????????????????????????????????????????????????????"
echo "?   Setup Cluster Kubernetes Local - Demo Minikube          ?"
echo "?   Laravel APIs + Angular Frontend                          ?"
echo "??????????????????????????????????????????????????????????????"
echo -e "${NC}"

# Verificar depend?ncias
echo -e "${YELLOW}?? Verificando depend?ncias...${NC}"

check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}? $1 n?o est? instalado. Por favor, instale antes de continuar.${NC}"
        exit 1
    else
        echo -e "${GREEN}? $1 encontrado${NC}"
    fi
}

check_command minikube
check_command kubectl
check_command docker

# Verificar se o Minikube est? rodando
echo -e "\n${YELLOW}?? Verificando status do Minikube...${NC}"
if ! minikube status &> /dev/null; then
    echo -e "${YELLOW}??  Iniciando Minikube...${NC}"
    minikube start --driver=docker --cpus=4 --memory=4096
    echo -e "${GREEN}? Minikube iniciado com sucesso!${NC}"
else
    echo -e "${GREEN}? Minikube j? est? rodando${NC}"
fi

# Configurar kubectl para usar o contexto do Minikube
kubectl config use-context minikube

# Habilitar addons necess?rios
echo -e "\n${YELLOW}?? Habilitando addons do Minikube...${NC}"
minikube addons enable ingress
minikube addons enable metrics-server
echo -e "${GREEN}? Addons habilitados${NC}"

# Configurar Docker para usar o daemon do Minikube
echo -e "\n${YELLOW}?? Configurando Docker para usar o daemon do Minikube...${NC}"
eval $(minikube docker-env)
echo -e "${GREEN}? Docker configurado${NC}"

# Build das imagens Docker
echo -e "\n${YELLOW}???  Construindo imagens Docker...${NC}"

echo -e "${BLUE}Building Users API...${NC}"
docker build -t users-api:latest ../backend-users/

echo -e "${BLUE}Building Products API...${NC}"
docker build -t products-api:latest ../backend-products/

echo -e "${BLUE}Building Frontend...${NC}"
docker build -t frontend:latest ../frontend/

echo -e "${GREEN}? Todas as imagens foram constru?das com sucesso!${NC}"

# Criar namespace
echo -e "\n${YELLOW}?? Criando namespace...${NC}"
kubectl apply -f ../k8s/namespace.yaml
echo -e "${GREEN}? Namespace criado${NC}"

# Aplicar ConfigMap
echo -e "\n${YELLOW}??  Aplicando ConfigMap...${NC}"
kubectl apply -f ../k8s/configmap.yaml
echo -e "${GREEN}? ConfigMap aplicado${NC}"

# Deploy das aplica??es
echo -e "\n${YELLOW}?? Fazendo deploy das aplica??es...${NC}"

echo -e "${BLUE}Deploying Users API...${NC}"
kubectl apply -f ../k8s/users-api-deployment.yaml

echo -e "${BLUE}Deploying Products API...${NC}"
kubectl apply -f ../k8s/products-api-deployment.yaml

echo -e "${BLUE}Deploying Frontend...${NC}"
kubectl apply -f ../k8s/frontend-deployment.yaml

echo -e "${GREEN}? Deployments criados com sucesso!${NC}"

# Aplicar Ingress
echo -e "\n${YELLOW}?? Configurando Ingress...${NC}"
kubectl apply -f ../k8s/ingress.yaml
echo -e "${GREEN}? Ingress configurado${NC}"

# Aguardar os pods ficarem prontos
echo -e "\n${YELLOW}? Aguardando pods ficarem prontos...${NC}"
kubectl wait --for=condition=ready pod -l app=users-api --timeout=120s || true
kubectl wait --for=condition=ready pod -l app=products-api --timeout=120s || true
kubectl wait --for=condition=ready pod -l app=frontend --timeout=120s || true

# Configurar hosts
echo -e "\n${YELLOW}?? Configurando /etc/hosts...${NC}"
MINIKUBE_IP=$(minikube ip)
echo -e "${BLUE}IP do Minikube: ${MINIKUBE_IP}${NC}"

echo -e "${YELLOW}Adicione as seguintes entradas no seu /etc/hosts:${NC}"
echo -e "${GREEN}$MINIKUBE_IP demo.local${NC}"
echo -e "${GREEN}$MINIKUBE_IP users-api.local${NC}"
echo -e "${GREEN}$MINIKUBE_IP products-api.local${NC}"

echo -e "\n${YELLOW}Execute o seguinte comando (requer senha):${NC}"
echo -e "${BLUE}sudo bash -c 'echo \"$MINIKUBE_IP demo.local\" >> /etc/hosts'${NC}"
echo -e "${BLUE}sudo bash -c 'echo \"$MINIKUBE_IP users-api.local\" >> /etc/hosts'${NC}"
echo -e "${BLUE}sudo bash -c 'echo \"$MINIKUBE_IP products-api.local\" >> /etc/hosts'${NC}"

# Status final
echo -e "\n${GREEN}"
echo "??????????????????????????????????????????????????????????????"
echo "?               ? Setup Conclu?do com Sucesso!              ?"
echo "??????????????????????????????????????????????????????????????"
echo -e "${NC}"

echo -e "${YELLOW}?? Status do Cluster:${NC}"
kubectl get pods -o wide
echo ""
kubectl get services
echo ""
kubectl get ingress

echo -e "\n${YELLOW}?? URLs de Acesso:${NC}"
echo -e "${GREEN}Frontend:      http://demo.local${NC}"
echo -e "${GREEN}Users API:     http://users-api.local/api/users${NC}"
echo -e "${GREEN}Products API:  http://products-api.local/api/products${NC}"

echo -e "\n${YELLOW}?? Pr?ximos passos:${NC}"
echo -e "1. Configure o /etc/hosts com os comandos acima"
echo -e "2. Acesse http://demo.local no seu navegador"
echo -e "3. Use ${BLUE}./scripts/status.sh${NC} para verificar o status"
echo -e "4. Use ${BLUE}./scripts/logs.sh${NC} para ver os logs"
echo -e "5. Use ${BLUE}./scripts/cleanup.sh${NC} para limpar tudo"

echo -e "\n${GREEN}?? Boa aula!${NC}\n"

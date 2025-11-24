#!/bin/bash

###############################################################################
# Script de Setup do Cluster Kubernetes com Minikube
# Demonstração para aula - Sistema de Microserviços
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

echo -e "${BLUE}"
echo "═══════════════════════════════════════════════════════════════"
echo "║   Setup Cluster Kubernetes Local - Demo Minikube          ║"
echo "║   Laravel APIs + Angular Frontend                          ║"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

# Verificar dependências
echo -e "${YELLOW}🔍 Verificando dependências...${NC}"

check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}❌ $1 não está instalado. Por favor, instale antes de continuar.${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ $1 encontrado${NC}"
    fi
}

check_command minikube
check_command kubectl
check_command docker

# Verificar se o Minikube está rodando
echo -e "\n${YELLOW}🔍 Verificando status do Minikube...${NC}"

# Verificar driver disponível no macOS
if command -v hyperkit &> /dev/null; then
    DRIVER="hyperkit"
elif command -v virtualbox &> /dev/null; then
    DRIVER="virtualbox"
else
    echo -e "${YELLOW}⚠️  HyperKit ou VirtualBox não encontrado. Tentando usar driver padrão...${NC}"
    DRIVER=""
fi

if ! minikube status &> /dev/null; then
    echo -e "${YELLOW}🚀 Iniciando Minikube com driver nativo do macOS...${NC}"
    if [ -n "$DRIVER" ]; then
        minikube start --driver=$DRIVER --cpus=4 --memory=4096
    else
        minikube start --cpus=4 --memory=4096
    fi
    echo -e "${GREEN}✅ Minikube iniciado com sucesso!${NC}"
else
    echo -e "${GREEN}✅ Minikube já está rodando${NC}"
fi

# Configurar kubectl para usar o contexto do Minikube
kubectl config use-context minikube

# Habilitar addons necessários
echo -e "\n${YELLOW}⚙️  Habilitando addons do Minikube...${NC}"
minikube addons enable ingress
minikube addons enable metrics-server
minikube addons enable dashboard
echo -e "${GREEN}✅ Addons habilitados${NC}"

# Configurar Docker para usar o daemon do Minikube (necessário para build de imagens)
echo -e "\n${YELLOW}🔧 Configurando Docker para usar o daemon do Minikube...${NC}"
eval $(minikube docker-env)
echo -e "${GREEN}✅ Docker configurado${NC}"

# Build das imagens Docker
echo -e "\n${YELLOW}🔨 Construindo imagens Docker...${NC}"

# Desabilitar BuildKit para mostrar output completo (builder legado mostra tudo por padrão)
export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0

echo -e "${BLUE}Building Users API...${NC}"
docker build -t users-api:latest ../backend-users/

echo -e "${BLUE}Building Products API...${NC}"
docker build -t products-api:latest ../backend-products/

echo -e "${BLUE}Building Frontend...${NC}"
docker build -t frontend:latest ../frontend/

echo -e "${GREEN}✅ Todas as imagens foram construídas com sucesso!${NC}"

# Criar namespace
echo -e "\n${YELLOW}📦 Criando namespace...${NC}"
kubectl apply -f ../k8s/namespace.yaml
echo -e "${GREEN}✅ Namespace criado${NC}"

# Aplicar ConfigMap
echo -e "\n${YELLOW}📋 Aplicando ConfigMap...${NC}"
kubectl apply -f ../k8s/configmap.yaml
echo -e "${GREEN}✅ ConfigMap aplicado${NC}"

# Deploy das aplicações
echo -e "\n${YELLOW}🚀 Fazendo deploy das aplicações...${NC}"

echo -e "${BLUE}Deploying Users API...${NC}"
kubectl apply -f ../k8s/users-api-deployment.yaml -n demo-k8s

echo -e "${BLUE}Deploying Products API...${NC}"
kubectl apply -f ../k8s/products-api-deployment.yaml -n demo-k8s

echo -e "${BLUE}Deploying Frontend...${NC}"
kubectl apply -f ../k8s/frontend-deployment.yaml -n demo-k8s

echo -e "${GREEN}✅ Deployments criados com sucesso!${NC}"

# Aplicar Ingress
echo -e "\n${YELLOW}🌐 Configurando Ingress...${NC}"
kubectl apply -f ../k8s/ingress.yaml -n demo-k8s
echo -e "${GREEN}✅ Ingress configurado${NC}"

# Aguardar os pods ficarem prontos
echo -e "\n${YELLOW}⏳ Aguardando pods ficarem prontos...${NC}"
kubectl wait --for=condition=ready pod -l app=users-api -n demo-k8s --timeout=120s || true
kubectl wait --for=condition=ready pod -l app=products-api -n demo-k8s --timeout=120s || true
kubectl wait --for=condition=ready pod -l app=frontend -n demo-k8s --timeout=120s || true

# Configurar hosts
echo -e "\n${YELLOW}📝 Configurando /etc/hosts...${NC}"
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
echo "═══════════════════════════════════════════════════════════════"
echo "║               ✅ Setup Concluído com Sucesso!              ║"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

echo -e "${YELLOW}📊 Status do Cluster:${NC}"
kubectl get pods -o wide -n demo-k8s
echo ""
kubectl get services -n demo-k8s
echo ""
kubectl get ingress -n demo-k8s

echo -e "\n${YELLOW}🔗 URLs de Acesso:${NC}"
echo -e "${GREEN}Frontend:      http://demo.local${NC}"
echo -e "${GREEN}Users API:     http://users-api.local/api/users${NC}"
echo -e "${GREEN}Products API:  http://products-api.local/api/products${NC}"

echo -e "\n${YELLOW}📊 Kubernetes Dashboard:${NC}"
echo -e "${BLUE}Para acessar o Dashboard do Kubernetes, execute:${NC}"
echo -e "${GREEN}minikube dashboard${NC}"
echo -e "${BLUE}Ou acesse diretamente via proxy:${NC}"
echo -e "${GREEN}kubectl proxy --address='0.0.0.0' --port=8001 --accept-hosts='.*'${NC}"
echo -e "${BLUE}Depois acesse: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/${NC}"

echo -e "\n${YELLOW}🏠 Acesso via Localhost:${NC}"
echo -e "${BLUE}Para acessar os serviços via localhost, execute:${NC}"
echo -e "${GREEN}./scripts/port-forward.sh${NC}"
echo -e "${BLUE}Isso criará port-forwards para:${NC}"
echo -e "${GREEN}  Frontend:      http://localhost:8080${NC}"
echo -e "${GREEN}  Users API:     http://localhost:8081/api/health${NC}"
echo -e "${GREEN}  Products API:  http://localhost:8082/api/health${NC}"

echo -e "\n${YELLOW}📋 Próximos passos:${NC}"
echo -e "1. Configure o /etc/hosts com os comandos acima (para acesso via Ingress)"
echo -e "2. OU execute ${BLUE}./scripts/port-forward.sh${NC} para acessar via localhost"
echo -e "3. Acesse http://demo.local no seu navegador (após configurar /etc/hosts)"
echo -e "4. Use ${BLUE}./scripts/status.sh${NC} para verificar o status"
echo -e "5. Use ${BLUE}./scripts/logs.sh${NC} para ver os logs"
echo -e "6. Use ${BLUE}./scripts/cleanup.sh${NC} para limpar tudo"

echo -e "\n${GREEN}🎓 Boa aula!${NC}\n"

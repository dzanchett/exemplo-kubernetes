
#!/bin/bash

###############################################################################
# Script para criar túnel do Minikube e acessar via Ingress
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
echo "║   Minikube Tunnel - Acesso via Ingress                    ║"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

# Verificar se o namespace existe
NAMESPACE="demo-k8s"
if ! kubectl get namespace $NAMESPACE &> /dev/null; then
    echo -e "${RED}❌ Namespace $NAMESPACE não encontrado. Execute ./setup.sh primeiro.${NC}"
    exit 1
fi

# Obter IP do Minikube
MINIKUBE_IP=$(minikube ip)
echo -e "${YELLOW}📝 IP do Minikube: ${MINIKUBE_IP}${NC}"

echo -e "\n${YELLOW}📋 Adicione ao seu /etc/hosts:${NC}"
echo -e "${GREEN}${MINIKUBE_IP} demo.local${NC}"
echo -e "${GREEN}${MINIKUBE_IP} users-api.local${NC}"
echo -e "${GREEN}${MINIKUBE_IP} products-api.local${NC}"

echo -e "\n${BLUE}Execute:${NC}"
echo -e "${GREEN}sudo bash -c 'echo \"${MINIKUBE_IP} demo.local\" >> /etc/hosts'${NC}"
echo -e "${GREEN}sudo bash -c 'echo \"${MINIKUBE_IP} users-api.local\" >> /etc/hosts'${NC}"
echo -e "${GREEN}sudo bash -c 'echo \"${MINIKUBE_IP} products-api.local\" >> /etc/hosts'${NC}"

echo -e "\n${YELLOW}🔗 URLs de Acesso:${NC}"
echo -e "${GREEN}Frontend:      http://demo.local${NC}"
echo -e "${GREEN}Users API:     http://users-api.local/api/users${NC}"
echo -e "${GREEN}Products API:  http://products-api.local/api/products${NC}"

echo -e "\n${YELLOW}🚇 Iniciando túnel do Minikube...${NC}"
echo -e "${BLUE}Este comando precisa ficar rodando. Pressione Ctrl+C para parar.${NC}\n"

minikube tunnel


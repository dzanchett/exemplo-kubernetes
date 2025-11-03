#!/bin/bash

###############################################################################
# Script para visualizar logs das aplica??es
###############################################################################

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}"
echo "??????????????????????????????????????????????????????????????"
echo "?              Logs das Aplica??es - Kubernetes              ?"
echo "??????????????????????????????????????????????????????????????"
echo -e "${NC}"

echo -e "${YELLOW}Escolha qual aplica??o deseja ver os logs:${NC}"
echo -e "${GREEN}1)${NC} Users API"
echo -e "${GREEN}2)${NC} Products API"
echo -e "${GREEN}3)${NC} Frontend"
echo -e "${GREEN}4)${NC} Todos (tail -f)"
echo ""
read -p "Op??o: " option

case $option in
    1)
        echo -e "${BLUE}?? Logs do Users API:${NC}"
        POD=$(kubectl get pods -l app=users-api -o jsonpath='{.items[0].metadata.name}')
        kubectl logs -f $POD
        ;;
    2)
        echo -e "${BLUE}?? Logs do Products API:${NC}"
        POD=$(kubectl get pods -l app=products-api -o jsonpath='{.items[0].metadata.name}')
        kubectl logs -f $POD
        ;;
    3)
        echo -e "${BLUE}?? Logs do Frontend:${NC}"
        POD=$(kubectl get pods -l app=frontend -o jsonpath='{.items[0].metadata.name}')
        kubectl logs -f $POD
        ;;
    4)
        echo -e "${BLUE}?? Logs de todas as aplica??es:${NC}"
        echo -e "${YELLOW}Pressione Ctrl+C para sair${NC}"
        kubectl logs -f -l tier=backend &
        kubectl logs -f -l tier=frontend &
        wait
        ;;
    *)
        echo -e "${RED}Op??o inv?lida${NC}"
        exit 1
        ;;
esac

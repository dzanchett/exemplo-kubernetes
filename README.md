# ?? Demo Kubernetes com Minikube

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)
![Angular](https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white)

## ?? Sobre o Projeto

Este ? um projeto de demonstra??o educacional que implementa uma arquitetura de microservi?os usando Kubernetes local com Minikube. O projeto consiste em:

- **2 APIs Backend** implementadas em PHP com Laravel
  - API de Usu?rios
  - API de Produtos
- **1 Frontend** implementado com Angular
- **Orquestra??o** com Kubernetes (Minikube)
- **Containeriza??o** com Docker

## ?? Objetivo

Demonstrar na pr?tica os conceitos de:
- Containeriza??o de aplica??es
- Orquestra??o de containers com Kubernetes
- Microservi?os
- Service Discovery
- Ingress e roteamento
- Health Checks e Probes
- Escalabilidade horizontal

## ??? Arquitetura

```
???????????????????????????????????????????????????????????????
?                         Ingress                              ?
?                  (nginx-ingress-controller)                  ?
???????????????????????????????????????????????????????????????
             ?                ?                ?
             ?                ?                ?
        ????????????    ????????????    ????????????
        ? Frontend ?    ? Users    ?    ? Products ?
        ? Service  ?    ? API      ?    ? API      ?
        ?          ?    ? Service  ?    ? Service  ?
        ????????????    ????????????    ????????????
             ?                ?                ?
        ????????????    ????????????    ????????????
        ? Frontend ?    ? Users    ?    ? Products ?
        ? Pod      ?    ? API Pod  ?    ? API Pod  ?
        ? (x2)     ?    ? (x2)     ?    ? (x2)     ?
        ????????????    ????????????    ????????????
```

## ??? Tecnologias Utilizadas

### Backend
- **PHP 8.2**
- **Laravel 10**
- **Apache**
- **Composer**

### Frontend
- **Angular 17**
- **TypeScript**
- **RxJS**
- **Nginx**

### DevOps
- **Docker** - Containeriza??o
- **Kubernetes** - Orquestra??o
- **Minikube** - Cluster local
- **kubectl** - CLI do Kubernetes

## ?? Pr?-requisitos

Antes de iniciar, certifique-se de ter instalado em seu Mac:

### Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Docker Desktop
```bash
brew install --cask docker
```

### Minikube
```bash
brew install minikube
```

### kubectl
```bash
brew install kubectl
```

### Verificar Instala??o
```bash
docker --version
minikube version
kubectl version --client
```

## ?? In?cio R?pido

### 1. Clone o Reposit?rio
```bash
git clone <seu-repositorio>
cd <nome-do-projeto>
```

### 2. Execute o Setup Autom?tico
```bash
cd scripts
./setup.sh
```

O script `setup.sh` ir?:
- ? Verificar todas as depend?ncias
- ? Iniciar o Minikube
- ? Habilitar addons necess?rios (ingress, metrics-server)
- ? Construir todas as imagens Docker
- ? Criar namespace e recursos Kubernetes
- ? Fazer deploy de todas as aplica??es
- ? Configurar o Ingress

### 3. Configure o /etc/hosts

Ap?s executar o setup, adicione as seguintes entradas ao seu `/etc/hosts`:

```bash
# Obt?m o IP do Minikube
MINIKUBE_IP=$(minikube ip)

# Adiciona as entradas (requer senha)
sudo bash -c "echo \"$MINIKUBE_IP demo.local\" >> /etc/hosts"
sudo bash -c "echo \"$MINIKUBE_IP users-api.local\" >> /etc/hosts"
sudo bash -c "echo \"$MINIKUBE_IP products-api.local\" >> /etc/hosts"
```

### 4. Acesse as Aplica??es

- **Frontend**: [http://demo.local](http://demo.local)
- **Users API**: [http://users-api.local/api/users](http://users-api.local/api/users)
- **Products API**: [http://products-api.local/api/products](http://products-api.local/api/products)

## ??? Scripts Dispon?veis

Todos os scripts est?o na pasta `scripts/`:

| Script | Descri??o |
|--------|-----------|
| `setup.sh` | Configura todo o ambiente do zero |
| `status.sh` | Exibe o status completo do cluster |
| `logs.sh` | Visualiza logs das aplica??es |
| `rebuild.sh` | Reconstr?i imagens e atualiza deployments |
| `test-apis.sh` | Testa todos os endpoints das APIs |
| `cleanup.sh` | Remove todos os recursos do cluster |

### Exemplos de Uso

```bash
# Ver status do cluster
./scripts/status.sh

# Ver logs da API de usu?rios
./scripts/logs.sh
# Escolha op??o 1

# Testar todas as APIs
./scripts/test-apis.sh

# Rebuildar apenas o frontend
./scripts/rebuild.sh
# Escolha op??o 3

# Limpar tudo
./scripts/cleanup.sh
```

## ?? Estrutura do Projeto

```
.
??? backend-users/          # API de Usu?rios (Laravel)
?   ??? app/
?   ??? routes/
?   ??? public/
?   ??? Dockerfile
?   ??? composer.json
?
??? backend-products/       # API de Produtos (Laravel)
?   ??? app/
?   ??? routes/
?   ??? public/
?   ??? Dockerfile
?   ??? composer.json
?
??? frontend/               # Frontend (Angular)
?   ??? src/
?   ??? angular.json
?   ??? package.json
?   ??? Dockerfile
?   ??? nginx.conf
?
??? k8s/                    # Manifestos Kubernetes
?   ??? namespace.yaml
?   ??? configmap.yaml
?   ??? users-api-deployment.yaml
?   ??? products-api-deployment.yaml
?   ??? frontend-deployment.yaml
?   ??? ingress.yaml
?
??? scripts/                # Scripts de automa??o
?   ??? setup.sh
?   ??? status.sh
?   ??? logs.sh
?   ??? rebuild.sh
?   ??? test-apis.sh
?   ??? cleanup.sh
?
??? README.md
```

## ?? Endpoints das APIs

### Users API

| M?todo | Endpoint | Descri??o |
|--------|----------|-----------|
| GET | `/api/health` | Health check |
| GET | `/api/users` | Lista todos os usu?rios |
| GET | `/api/users/{id}` | Retorna usu?rio espec?fico |

### Products API

| M?todo | Endpoint | Descri??o |
|--------|----------|-----------|
| GET | `/api/health` | Health check |
| GET | `/api/products` | Lista todos os produtos |
| GET | `/api/products/{id}` | Retorna produto espec?fico |

## ?? Testando as APIs

### Via curl

```bash
# Health check Users API
curl http://users-api.local/api/health

# Listar usu?rios
curl http://users-api.local/api/users

# Usu?rio espec?fico
curl http://users-api.local/api/users/1

# Health check Products API
curl http://products-api.local/api/health

# Listar produtos
curl http://products-api.local/api/products

# Produto espec?fico
curl http://products-api.local/api/products/1
```

### Via Script

```bash
./scripts/test-apis.sh
```

## ?? Monitoramento

### Ver Status dos Pods
```bash
kubectl get pods -o wide
```

### Ver Logs de um Pod
```bash
# Listar pods
kubectl get pods

# Ver logs
kubectl logs <nome-do-pod>

# Seguir logs em tempo real
kubectl logs -f <nome-do-pod>
```

### Ver M?tricas de Recursos
```bash
kubectl top nodes
kubectl top pods
```

### Dashboard do Kubernetes
```bash
minikube dashboard
```

## ?? Troubleshooting

### Pods n?o iniciam

```bash
# Ver detalhes do pod
kubectl describe pod <nome-do-pod>

# Ver eventos
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Imagens n?o s?o encontradas

```bash
# Certificar que est? usando o Docker do Minikube
eval $(minikube docker-env)

# Rebuildar imagens
cd scripts
./rebuild.sh
```

### DNS n?o resolve (demo.local, etc)

```bash
# Verificar IP do Minikube
minikube ip

# Verificar /etc/hosts
cat /etc/hosts | grep ".local"

# Se necess?rio, reconfigurar
MINIKUBE_IP=$(minikube ip)
sudo bash -c "echo \"$MINIKUBE_IP demo.local\" >> /etc/hosts"
```

### Ingress n?o funciona

```bash
# Verificar se o addon est? habilitado
minikube addons list | grep ingress

# Habilitar se necess?rio
minikube addons enable ingress

# Verificar controller
kubectl get pods -n ingress-nginx
```

## ?? Conceitos Demonstrados

### 1. Containeriza??o
- Dockerfile multi-stage (frontend)
- Otimiza??o de imagens
- .dockerignore

### 2. Kubernetes
- Deployments
- Services (ClusterIP)
- Ingress
- ConfigMaps
- Namespaces
- Labels e Selectors

### 3. High Availability
- M?ltiplas r?plicas (2 por servi?o)
- Health checks (liveness e readiness probes)
- Rolling updates

### 4. Networking
- Service Discovery
- DNS interno do Kubernetes
- Ingress para roteamento externo

### 5. Resource Management
- Resource requests e limits
- Pod scheduling

## ?? Comandos ?teis

```bash
# Kubernetes
kubectl get all                          # Ver todos os recursos
kubectl get pods -w                      # Watch pods
kubectl describe pod <pod-name>          # Detalhes do pod
kubectl logs <pod-name>                  # Ver logs
kubectl exec -it <pod-name> -- bash      # Entrar no pod
kubectl port-forward <pod> 8080:80       # Port forward

# Minikube
minikube status                          # Status do cluster
minikube ip                              # IP do cluster
minikube ssh                             # SSH no node
minikube dashboard                       # Dashboard web
minikube service list                    # Listar servi?os
minikube addons list                     # Listar addons

# Docker (no contexto do Minikube)
eval $(minikube docker-env)              # Usar Docker do Minikube
docker images                            # Listar imagens
docker ps                                # Containers rodando
```

## ?? Limpeza

Para remover todos os recursos:

```bash
cd scripts
./cleanup.sh
```

O script oferece op??es para:
- Remover apenas os recursos Kubernetes
- Parar o Minikube
- Deletar completamente o cluster Minikube

## ?? Contribuindo

Este ? um projeto educacional. Sugest?es e melhorias s?o bem-vindas!

## ?? Licen?a

MIT License - Projeto para fins educacionais

## ????? Instru??es para o Professor

### Prepara??o da Aula

1. **Antes da Aula:**
   - Teste todo o setup em sua m?quina
   - Verifique se todas as URLs est?o acess?veis
   - Prepare slides explicando a arquitetura

2. **Durante a Demonstra??o:**
   - Mostre o `./scripts/status.sh` para visualizar o cluster
   - Use o `./scripts/logs.sh` para mostrar logs em tempo real
   - Demonstre escalabilidade modificando replicas
   - Mostre o dashboard do Minikube

3. **Exerc?cios Sugeridos:**
   - Adicionar uma nova API
   - Modificar n?mero de r?plicas
   - Adicionar vari?veis de ambiente
   - Implementar um novo endpoint

### Pontos de Discuss?o

- Por que usar Kubernetes?
- Diferen?a entre Docker e Kubernetes
- Como funciona o Service Discovery
- Load balancing entre pods
- Rolling updates vs Recreate
- Resource management
- Health checks

## ?? Suporte

Para d?vidas e problemas:
- Abra uma issue no reposit?rio
- Consulte a documenta??o oficial do [Kubernetes](https://kubernetes.io/docs/)
- Consulte a documenta??o do [Minikube](https://minikube.sigs.k8s.io/docs/)

---

**Desenvolvido para fins educacionais** ??

*Demo de Kubernetes com Minikube - Laravel + Angular*

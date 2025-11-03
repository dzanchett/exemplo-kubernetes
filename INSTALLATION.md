# ?? Guia de Instala??o Completo - macOS

Este guia detalha passo a passo a instala??o de todas as depend?ncias necess?rias para executar o projeto no macOS.

## ?? ?ndice

1. [Homebrew](#homebrew)
2. [Docker Desktop](#docker-desktop)
3. [Minikube](#minikube)
4. [kubectl](#kubectl)
5. [Ferramentas Opcionais](#ferramentas-opcionais)
6. [Verifica??o Final](#verifica??o-final)
7. [Troubleshooting](#troubleshooting)

## ?? Homebrew

Homebrew ? o gerenciador de pacotes para macOS.

### Instala??o

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Verifica??o

```bash
brew --version
```

Sa?da esperada:
```
Homebrew 4.x.x
```

## ?? Docker Desktop

Docker Desktop para Mac inclui Docker Engine, Docker CLI, Docker Compose.

### Op??o 1: Via Homebrew (Recomendado)

```bash
brew install --cask docker
```

### Op??o 2: Download Direto

1. Acesse [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. Baixe o Docker Desktop para Mac (escolha Apple Silicon ou Intel)
3. Arraste Docker.app para a pasta Applications
4. Abra o Docker Desktop e aceite os termos

### Configura??o Inicial

1. Abra o Docker Desktop
2. V? em Preferences (??)
3. Configure os recursos:
   - **CPUs**: 4 ou mais
   - **Memory**: 4GB ou mais
   - **Disk**: 20GB ou mais

### Verifica??o

```bash
docker --version
docker ps
```

Sa?da esperada:
```
Docker version 24.x.x
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## ?? Minikube

Minikube executa um cluster Kubernetes local.

### Instala??o

```bash
brew install minikube
```

### Configura??o Inicial

```bash
# Iniciar Minikube com configura??es adequadas
minikube start --driver=docker --cpus=4 --memory=4096
```

Par?metros:
- `--driver=docker`: Usa Docker como driver
- `--cpus=4`: Aloca 4 CPUs
- `--memory=4096`: Aloca 4GB de RAM

### Comandos ?teis

```bash
# Status
minikube status

# Parar
minikube stop

# Deletar
minikube delete

# Dashboard
minikube dashboard

# IP do cluster
minikube ip

# SSH no node
minikube ssh
```

### Verifica??o

```bash
minikube version
minikube status
```

Sa?da esperada:
```
minikube version: v1.x.x
commit: xxxxx

minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

## ?? kubectl

kubectl ? a CLI para interagir com clusters Kubernetes.

### Instala??o

```bash
brew install kubectl
```

### Configura??o

O kubectl ? automaticamente configurado pelo Minikube, mas voc? pode verificar:

```bash
# Ver contextos dispon?veis
kubectl config get-contexts

# Usar contexto do Minikube
kubectl config use-context minikube

# Ver configura??o atual
kubectl config current-context
```

### Verifica??o

```bash
kubectl version --client
kubectl cluster-info
```

Sa?da esperada:
```
Client Version: v1.x.x
Kustomize Version: v5.x.x

Kubernetes control plane is running at https://xxx.xxx.xxx.xxx:8443
```

### Autocompletion (Opcional)

```bash
# Para Bash
echo 'source <(kubectl completion bash)' >>~/.bash_profile

# Para Zsh
echo 'source <(kubectl completion zsh)' >>~/.zshrc

# Recarregar shell
source ~/.zshrc  # ou ~/.bash_profile
```

## ??? Ferramentas Opcionais

### k9s - Terminal UI para Kubernetes

```bash
brew install k9s
```

Uso:
```bash
k9s
```

### kubectx e kubens - Switch de contextos

```bash
brew install kubectx
```

Uso:
```bash
# Listar contextos
kubectx

# Trocar contexto
kubectx minikube

# Listar namespaces
kubens

# Trocar namespace
kubens default
```

### Helm - Package Manager para Kubernetes

```bash
brew install helm
```

Verifica??o:
```bash
helm version
```

### stern - Tail logs de m?ltiplos pods

```bash
brew install stern
```

Uso:
```bash
stern <pod-name-pattern>
```

## ? Verifica??o Final

Execute este script para verificar todas as instala??es:

```bash
#!/bin/bash

echo "?? Verificando instala??es..."
echo ""

# Fun??o para verificar comando
check_command() {
    if command -v $1 &> /dev/null; then
        version=$($1 --version 2>&1 | head -n 1)
        echo "? $1: $version"
    else
        echo "? $1: N?O INSTALADO"
    fi
}

check_command brew
check_command docker
check_command minikube
check_command kubectl

echo ""
echo "?? Status do Docker:"
docker ps &> /dev/null && echo "? Docker est? rodando" || echo "? Docker n?o est? rodando"

echo ""
echo "??  Status do Minikube:"
minikube status &> /dev/null && echo "? Minikube est? rodando" || echo "??  Minikube n?o est? rodando (execute: minikube start)"

echo ""
echo "?? Recursos do Sistema:"
echo "CPUs: $(sysctl -n hw.ncpu)"
echo "Mem?ria: $(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 ))GB"
```

Salve como `check-installation.sh`, torne execut?vel e execute:

```bash
chmod +x check-installation.sh
./check-installation.sh
```

## ?? Troubleshooting

### Problema: Docker n?o inicia

**Solu??o:**
```bash
# Reiniciar Docker
killall Docker && open /Applications/Docker.app

# Ou reinstalar
brew reinstall --cask docker
```

### Problema: Minikube n?o inicia

**Solu??o 1 - Deletar e recriar:**
```bash
minikube delete
minikube start --driver=docker --cpus=4 --memory=4096
```

**Solu??o 2 - Mudar driver:**
```bash
# Listar drivers dispon?veis
minikube start --help | grep driver

# Tentar com hyperkit (se instalado)
minikube start --driver=hyperkit
```

**Solu??o 3 - Limpar cache:**
```bash
rm -rf ~/.minikube
minikube start --driver=docker
```

### Problema: kubectl n?o conecta

**Solu??o:**
```bash
# Reconfigurar kubectl
kubectl config use-context minikube

# Verificar conex?o
kubectl cluster-info

# Se necess?rio, reiniciar Minikube
minikube stop
minikube start
```

### Problema: Permiss?es negadas

**Solu??o:**
```bash
# Adicionar usu?rio ao grupo docker (se aplic?vel)
sudo usermod -aG docker $USER

# Reiniciar terminal
```

### Problema: Porta j? em uso

**Solu??o:**
```bash
# Verificar qual processo est? usando a porta
lsof -i :8443  # ou outra porta

# Matar processo se necess?rio
kill -9 <PID>

# Reiniciar Minikube em outra porta
minikube start --apiserver-port=8444
```

### Problema: Recursos insuficientes

**Solu??o:**
```bash
# Iniciar com menos recursos
minikube start --driver=docker --cpus=2 --memory=2048

# Verificar recursos dispon?veis
docker info | grep -E "CPUs|Total Memory"
```

## ?? Recursos Adicionais

### Documenta??o Oficial

- [Docker Desktop para Mac](https://docs.docker.com/desktop/mac/)
- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/)

### Tutoriais

- [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Docker Getting Started](https://docs.docker.com/get-started/)

### Comunidade

- [Kubernetes Slack](https://slack.kubernetes.io/)
- [Docker Community Forums](https://forums.docker.com/)

## ?? Pr?ximos Passos

Ap?s concluir todas as instala??es:

1. Execute o projeto demo:
   ```bash
   cd scripts
   ./setup.sh
   ```

2. Leia o README principal para entender a arquitetura

3. Explore os exemplos pr?ticos

---

**Tempo estimado de instala??o:** 20-30 minutos

**?ltima atualiza??o:** 2024

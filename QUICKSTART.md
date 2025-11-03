# ? Quick Start Guide

Guia r?pido de 5 minutos para ter tudo funcionando!

## ? Pr?-requisitos

Voc? precisa ter instalado:
- Docker Desktop
- Minikube
- kubectl

> **N?o tem instalado?** Veja [INSTALLATION.md](INSTALLATION.md) para instru??es detalhadas.

## ?? Setup em 5 Minutos

### 1?? Clone e Entre no Diret?rio

```bash
cd <diret?rio-do-projeto>
```

### 2?? Execute o Setup

```bash
cd scripts
./setup.sh
```

Isso vai:
- ? Verificar depend?ncias
- ? Iniciar Minikube
- ? Construir imagens Docker
- ? Fazer deploy no Kubernetes
- ? Configurar Ingress

?? **Tempo estimado:** 3-5 minutos

### 3?? Configure o /etc/hosts

```bash
# Obter IP do Minikube
MINIKUBE_IP=$(minikube ip)

# Adicionar hosts (pede senha do sudo)
sudo bash -c "echo \"$MINIKUBE_IP demo.local\" >> /etc/hosts"
sudo bash -c "echo \"$MINIKUBE_IP users-api.local\" >> /etc/hosts"
sudo bash -c "echo \"$MINIKUBE_IP products-api.local\" >> /etc/hosts"
```

### 4?? Aguarde os Pods Ficarem Prontos

```bash
# Verificar status
./status.sh

# Deve mostrar todos os pods como "Running"
```

### 5?? Acesse a Aplica??o! ??

Abra no navegador:
- **Frontend:** [http://demo.local](http://demo.local)

Ou teste as APIs:
```bash
# Users API
curl http://users-api.local/api/users

# Products API
curl http://products-api.local/api/products
```

## ?? Comandos ?teis

```bash
# Ver status completo
./scripts/status.sh

# Ver logs
./scripts/logs.sh

# Testar APIs
./scripts/test-apis.sh

# Reconstruir uma aplica??o
./scripts/rebuild.sh

# Limpar tudo
./scripts/cleanup.sh
```

## ? Problemas?

### Pods n?o ficam prontos

```bash
# Ver detalhes
kubectl get pods
kubectl describe pod <nome-do-pod>

# Ver logs
kubectl logs <nome-do-pod>
```

### URLs n?o funcionam

```bash
# Verificar se hosts foram configurados
cat /etc/hosts | grep ".local"

# Verificar IP do Minikube
minikube ip

# Reconfigurar se necess?rio
```

### Minikube n?o inicia

```bash
# Deletar e recriar
minikube delete
minikube start --driver=docker --cpus=4 --memory=4096
```

## ?? Pr?ximos Passos

1. Explore a [Arquitetura](ARCHITECTURE.md) do sistema
2. Leia o [README](README.md) completo
3. Experimente modificar e rebuildar aplica??es
4. Teste escalar r?plicas:
   ```bash
   kubectl scale deployment/users-api --replicas=5
   ```

## ?? Precisa de Ajuda?

- Veja [INSTALLATION.md](INSTALLATION.md) para instala??o detalhada
- Veja [README.md](README.md) para documenta??o completa
- Veja [ARCHITECTURE.md](ARCHITECTURE.md) para entender a arquitetura

---

**Boa aula!** ??

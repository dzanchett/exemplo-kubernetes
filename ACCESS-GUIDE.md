# 🌐 Guia de Acesso ao Sistema

## ✅ Status Atual
- ✅ Todos os pods estão rodando (READY 1/1)
- ✅ Backend APIs funcionando perfeitamente
- ✅ Frontend deployado e funcionando
- ✅ Health checks passando

---

## 🏠 Opção 1: Acesso via Port-Forward (RECOMENDADO - Mais Simples)

### Passo 1: Executar Port-Forward

```bash
cd /Users/diegozanchett/Documents/cursor/exemplo-kubernetes/scripts
./port-forward.sh
```

### Passo 2: Configurar /etc/hosts para o Frontend

O frontend precisa acessar as APIs. Adicione ao `/etc/hosts`:

```bash
sudo bash -c 'echo "127.0.0.1 users-api.local" >> /etc/hosts'
sudo bash -c 'echo "127.0.0.1 products-api.local" >> /etc/hosts'
```

### Passo 3: Acessar

- **Frontend**: http://localhost:8080
- **Users API**: http://localhost:8081/api/users
- **Products API**: http://localhost:8082/api/products

---

## 🚇 Opção 2: Acesso via Ingress (Minikube Tunnel)

### Passo 1: Executar Minikube Tunnel

Em um terminal separado:

```bash
cd /Users/diegozanchett/Documents/cursor/exemplo-kubernetes/scripts
./tunnel.sh
```

**⚠️ IMPORTANTE**: O túnel precisa ficar rodando (não feche o terminal)

### Passo 2: Acessar

- **Frontend**: http://demo.local
- **Users API**: http://users-api.local/api/users
- **Products API**: http://products-api.local/api/products

**Nota**: O `/etc/hosts` já está configurado com:
```
192.168.49.2 demo.local
192.168.49.2 users-api.local
192.168.49.2 products-api.local
```

---

## 🧪 Testar as APIs Diretamente

```bash
# Via Port-Forward
curl http://localhost:8081/api/health
curl http://localhost:8081/api/users
curl http://localhost:8082/api/health
curl http://localhost:8082/api/products

# Via Ingress (se tunnel estiver rodando)
curl http://users-api.local/api/health
curl http://users-api.local/api/users
curl http://products-api.local/api/health
curl http://products-api.local/api/products
```

---

## 📊 Verificar Status

```bash
cd /Users/diegozanchett/Documents/cursor/exemplo-kubernetes/scripts
./status.sh
```

---

## 🛑 Parar Serviços

- **Port-Forward**: Pressione `Ctrl+C` no terminal onde está rodando
- **Minikube Tunnel**: Pressione `Ctrl+C` no terminal do tunnel

---

## ❓ Troubleshooting

### Frontend não carrega dados

**Problema**: O frontend está acessando `users-api.local` e `products-api.local`, mas não consegue conectar.

**Solução com Port-Forward**:
```bash
# Adicione ao /etc/hosts
sudo bash -c 'echo "127.0.0.1 users-api.local" >> /etc/hosts'
sudo bash -c 'echo "127.0.0.1 products-api.local" >> /etc/hosts'
```

**Solução com Ingress**:
```bash
# Execute o tunnel
./scripts/tunnel.sh
```

### demo.local carrega infinitamente

**Causa**: Ingress sem ADDRESS (precisa do minikube tunnel)

**Solução**: Execute `./scripts/tunnel.sh` em outro terminal

### APIs não respondem

**Verificar pods**:
```bash
kubectl get pods -n demo-k8s
```

Todos devem estar `READY 1/1`. Se não estiverem, execute:
```bash
./scripts/quick-rebuild.sh
```

---

## 🎯 Recomendação

**Use Port-Forward** se você quer apenas testar o sistema rapidamente:
1. Execute `./scripts/port-forward.sh`
2. Configure o `/etc/hosts` com `127.0.0.1 users-api.local` e `products-api.local`
3. Acesse http://localhost:8080

**Use Ingress** se você quer simular um ambiente de produção:
1. Execute `./scripts/tunnel.sh` (precisa ficar rodando)
2. Acesse http://demo.local

---

Desenvolvido para fins educacionais 🎓


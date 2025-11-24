# 🔧 WAF Troubleshooting Guide

## Problemas Comuns e Soluções

---

## ❌ Erro: Ingress já definido

### Erro Completo
```
Error from server (BadRequest): error when creating "../k8s/ingress-with-bunkerweb.yaml": 
admission webhook "validate.nginx.ingress.kubernetes.io" denied the request: 
host "demo.local" and path "/" is already defined in ingress demo-k8s/demo-ingress
```

### Causa
O ingress antigo (`demo-ingress`) ainda existe e está usando os mesmos hosts.

### Solução

```bash
# 1. Deletar o ingress antigo
kubectl delete ingress demo-ingress -n demo-k8s

# 2. Aplicar o novo ingress com WAF
kubectl apply -f k8s/ingress-with-bunkerweb.yaml -n demo-k8s

# 3. Verificar
kubectl get ingress -n demo-k8s
```

### Solução Rápida (Script Corrigido)
O `setup.sh` já foi atualizado para resolver isso automaticamente. Execute:
```bash
./scripts/setup.sh
```

---

## ❌ BunkerWeb não está bloqueando ataques

### Sintomas
- Ataques passam sem ser bloqueados
- Retorna HTTP 200 ao invés de 403

### Verificações

#### 1. Verificar se o BunkerWeb está rodando
```bash
kubectl get pods -l app=bunkerweb -n demo-k8s
```

**Esperado:**
```
NAME                         READY   STATUS    RESTARTS   AGE
bunkerweb-xxx                1/1     Running   0          5m
```

#### 2. Verificar se o ingress está usando o WAF
```bash
kubectl get ingress -n demo-k8s -o yaml | grep "bunkerweb"
```

**Deve retornar:** `name: bunkerweb-service`

#### 3. Verificar logs do WAF
```bash
kubectl logs -l app=bunkerweb -n demo-k8s --tail=50
```

### Solução

Se o ingress não estiver usando o WAF:
```bash
# Aplicar o ingress correto
kubectl delete ingress demo-ingress-waf -n demo-k8s 2>/dev/null
kubectl delete ingress demo-ingress -n demo-k8s 2>/dev/null
kubectl apply -f k8s/ingress-with-bunkerweb.yaml -n demo-k8s
```

---

## ❌ WAF está bloqueando requisições legítimas

### Sintomas
- Requisições normais retornam HTTP 403
- Frontend não carrega corretamente

### Causa
WAF muito restritivo ou configuração CORS incorreta

### Solução

#### 1. Verificar configuração do BunkerWeb
```bash
kubectl describe deployment bunkerweb -n demo-k8s | grep -A 5 "MODSECURITY"
```

#### 2. Ajustar sensibilidade (temporário para testes)
```bash
kubectl set env deployment/bunkerweb -n demo-k8s \
  MODSECURITY_SEC_RULE_ENGINE=DetectionOnly
```

Isso coloca o WAF em modo de detecção (não bloqueia, apenas loga).

#### 3. Voltar ao modo de proteção
```bash
kubectl set env deployment/bunkerweb -n demo-k8s \
  MODSECURITY_SEC_RULE_ENGINE=On
```

---

## ❌ Pods do BunkerWeb não iniciam

### Sintomas
```
kubectl get pods -l app=bunkerweb -n demo-k8s
NAME                         READY   STATUS    RESTARTS   AGE
bunkerweb-xxx                0/1     Error     3          2m
```

### Verificações

#### 1. Ver logs do pod
```bash
POD=$(kubectl get pods -l app=bunkerweb -n demo-k8s -o name | head -1)
kubectl logs $POD -n demo-k8s
```

#### 2. Ver eventos
```bash
kubectl describe pod -l app=bunkerweb -n demo-k8s
```

### Soluções Comuns

#### Falta de recursos
```bash
# Verificar recursos disponíveis
kubectl top nodes

# Reduzir recursos do BunkerWeb
kubectl set resources deployment/bunkerweb -n demo-k8s \
  --requests=memory=128Mi,cpu=100m \
  --limits=memory=256Mi,cpu=200m
```

#### Imagem não encontrada
```bash
# Verificar se a imagem existe
kubectl describe pod -l app=bunkerweb -n demo-k8s | grep "Image:"

# Forçar pull da imagem
kubectl delete pod -l app=bunkerweb -n demo-k8s
```

---

## ❌ Erro de conexão (Connection refused)

### Sintomas
```bash
curl http://users-api.local/api/users
curl: (7) Failed to connect to users-api.local port 80: Connection refused
```

### Verificações

#### 1. Verificar /etc/hosts
```bash
cat /etc/hosts | grep ".local"
```

**Deve conter:**
```
192.168.49.2 demo.local
192.168.49.2 users-api.local
192.168.49.2 products-api.local
```

#### 2. Verificar IP do Minikube
```bash
minikube ip
```

### Solução

```bash
# Obter IP correto
MINIKUBE_IP=$(minikube ip)

# Atualizar /etc/hosts
sudo sed -i '' '/demo.local/d' /etc/hosts
sudo sed -i '' '/users-api.local/d' /etc/hosts
sudo sed -i '' '/products-api.local/d' /etc/hosts

sudo bash -c "echo \"$MINIKUBE_IP demo.local\" >> /etc/hosts"
sudo bash -c "echo \"$MINIKUBE_IP users-api.local\" >> /etc/hosts"
sudo bash -c "echo \"$MINIKUBE_IP products-api.local\" >> /etc/hosts"
```

---

## ❌ Logs do WAF não aparecem

### Sintomas
```bash
kubectl logs -l app=bunkerweb -n demo-k8s
# Sem output ou muito pouco
```

### Causa
WAF pode não estar recebendo tráfego

### Verificações

#### 1. Verificar se o ingress aponta para o WAF
```bash
kubectl describe ingress demo-ingress-waf -n demo-k8s | grep "bunkerweb"
```

#### 2. Fazer uma requisição de teste
```bash
curl -v http://users-api.local/api/users
```

#### 3. Ver logs em tempo real
```bash
kubectl logs -l app=bunkerweb -n demo-k8s -f
```

---

## ❌ Rate Limiting não funciona

### Sintomas
- Consegue fazer mais de 20 requisições/segundo
- Não recebe HTTP 429

### Verificações

#### 1. Verificar configuração
```bash
kubectl describe deployment bunkerweb -n demo-k8s | grep "LIMIT_REQ"
```

**Deve mostrar:**
```
LIMIT_REQ_RATE: 20r/s
LIMIT_REQ_BURST: 40
```

#### 2. Testar rate limiting
```bash
# Enviar 50 requisições rápidas
for i in {1..50}; do
  curl -w "HTTP %{http_code}\n" http://users-api.local/api/users
  sleep 0.01
done
```

### Solução

```bash
# Reiniciar WAF
kubectl rollout restart deployment/bunkerweb -n demo-k8s

# Aguardar
kubectl rollout status deployment/bunkerweb -n demo-k8s
```

---

## ❌ Scripts não funcionam (Permission denied)

### Sintomas
```bash
./scripts/test-waf.sh
-bash: ./scripts/test-waf.sh: Permission denied
```

### Solução
```bash
# Tornar todos os scripts executáveis
chmod +x scripts/*.sh

# Ou individualmente
chmod +x scripts/test-waf.sh
chmod +x scripts/attack-simulation.sh
chmod +x scripts/waf-manage.sh
```

---

## ❌ Endpoints vulneráveis não existem

### Sintomas
```bash
curl http://users-api.local/api/vulnerable/search
# 404 Not Found
```

### Causa
Backend não foi reconstruído após adicionar os novos endpoints

### Solução

```bash
cd scripts

# Reconstruir backends
./rebuild.sh
# Escolher opção 5 (Todas)

# Ou manualmente
eval $(minikube docker-env)
docker build -t users-api:latest ../backend-users/
docker build -t products-api:latest ../backend-products/
kubectl rollout restart deployment/users-api -n demo-k8s
kubectl rollout restart deployment/products-api -n demo-k8s
```

---

## ❌ Minikube não está rodando

### Sintomas
```bash
kubectl get pods
# Unable to connect to the server
```

### Solução
```bash
# Verificar status
minikube status

# Iniciar se necessário
minikube start

# Verificar novamente
kubectl get nodes
```

---

## 🔧 Comandos Úteis para Debugging

### Ver tudo no namespace
```bash
kubectl get all -n demo-k8s
```

### Ver eventos recentes
```bash
kubectl get events -n demo-k8s --sort-by=.metadata.creationTimestamp
```

### Ver logs de todos os pods
```bash
kubectl logs -l app=bunkerweb -n demo-k8s --all-containers=true
```

### Descrever ingress
```bash
kubectl describe ingress -n demo-k8s
```

### Verificar configuração do WAF
```bash
kubectl exec -it $(kubectl get pod -l app=bunkerweb -n demo-k8s -o name | head -1) -n demo-k8s -- env | grep -i modsecurity
```

### Testar conexão dentro do cluster
```bash
kubectl run test-pod --rm -i --tty --image=curlimages/curl -n demo-k8s -- sh
# Dentro do pod:
curl http://bunkerweb-service/api/users
```

---

## 🆘 Reset Completo

Se nada funcionar, faça um reset completo:

```bash
cd scripts

# 1. Limpar tudo
./cleanup.sh
# Escolher opção 1 (Deletar apenas recursos K8s)

# 2. Setup do zero
./setup.sh

# 3. Aguardar todos os pods
kubectl get pods -n demo-k8s -w

# 4. Testar
./test-waf.sh
```

---

## 📞 Ainda com Problemas?

### Checklist Final

- [ ] Minikube está rodando? `minikube status`
- [ ] Todos os pods estão Running? `kubectl get pods -n demo-k8s`
- [ ] Ingress existe e aponta para o WAF? `kubectl get ingress -n demo-k8s`
- [ ] /etc/hosts está configurado? `cat /etc/hosts | grep local`
- [ ] BunkerWeb está rodando? `kubectl get pods -l app=bunkerweb -n demo-k8s`
- [ ] Backends foram reconstruídos? `kubectl get pods -n demo-k8s`

### Coletar Informações para Suporte

```bash
# Criar arquivo de debug
echo "=== MINIKUBE STATUS ===" > debug.txt
minikube status >> debug.txt
echo "" >> debug.txt

echo "=== PODS ===" >> debug.txt
kubectl get pods -n demo-k8s -o wide >> debug.txt
echo "" >> debug.txt

echo "=== INGRESS ===" >> debug.txt
kubectl describe ingress -n demo-k8s >> debug.txt
echo "" >> debug.txt

echo "=== BUNKERWEB LOGS ===" >> debug.txt
kubectl logs -l app=bunkerweb -n demo-k8s --tail=100 >> debug.txt
echo "" >> debug.txt

echo "=== EVENTS ===" >> debug.txt
kubectl get events -n demo-k8s --sort-by=.metadata.creationTimestamp >> debug.txt

cat debug.txt
```

---

## 📚 Links Úteis

- [Documentação do BunkerWeb](https://docs.bunkerweb.io/)
- [Kubernetes Troubleshooting](https://kubernetes.io/docs/tasks/debug/)
- [Minikube Troubleshooting](https://minikube.sigs.k8s.io/docs/handbook/troubleshooting/)

---

**Última atualização:** 2024  
**Versão:** 1.0


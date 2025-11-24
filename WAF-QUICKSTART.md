# 🚀 Quick Start - WAF Demo

## Setup em 5 Minutos

### 1. Iniciar o Cluster

```bash
cd scripts
./setup.sh
```

Aguarde até que todos os pods estejam rodando (incluindo `bunkerweb`).

### 2. Verificar Status

```bash
kubectl get pods -l app=bunkerweb
# Deve mostrar: bunkerweb-xxx   1/1     Running
```

### 3. Testar Proteção

```bash
# Requisição normal - deve funcionar ✅
curl http://users-api.local/api/users

# Ataque SQL Injection - deve bloquear ❌ (403)
curl "http://users-api.local/api/vulnerable/search?q=admin' OR '1'='1"
```

### 4. Executar Testes Automatizados

```bash
# Teste completo do WAF
./scripts/test-waf.sh

# Simulação de ataques
./scripts/attack-simulation.sh
```

### 5. Ver Logs do WAF

```bash
# Tempo real
kubectl logs -l app=bunkerweb -f

# Últimas 50 linhas
kubectl logs -l app=bunkerweb --tail=50
```

---

## 🎯 Testes Rápidos

### SQL Injection
```bash
curl "http://users-api.local/api/vulnerable/search?q=admin' OR '1'='1"
# Esperado: HTTP 403 Forbidden
```

### XSS
```bash
curl "http://users-api.local/api/vulnerable/comment?text=<script>alert('XSS')</script>"
# Esperado: HTTP 403 Forbidden
```

### Path Traversal
```bash
curl "http://users-api.local/api/vulnerable/file?name=../../etc/passwd"
# Esperado: HTTP 403 Forbidden
```

### Command Injection
```bash
curl "http://users-api.local/api/vulnerable/ping?host=localhost;whoami"
# Esperado: HTTP 403 Forbidden
```

---

## 📊 Endpoints Disponíveis

### APIs Normais (Seguras)
- `http://users-api.local/api/users`
- `http://products-api.local/api/products`
- `http://demo.local` (Frontend)

### Endpoints Vulneráveis (Para Testes)
- `http://users-api.local/api/vulnerable/search` (SQL Injection)
- `http://users-api.local/api/vulnerable/comment` (XSS)
- `http://users-api.local/api/vulnerable/file` (Path Traversal)
- `http://users-api.local/api/vulnerable/ping` (Command Injection)
- `http://users-api.local/api/vulnerable/debug` (Info Disclosure)
- `http://products-api.local/api/vulnerable/fetch` (SSRF)
- `http://products-api.local/api/vulnerable/server-info` (Info Disclosure)

---

## 🔍 O que Observar

### Requisição BLOQUEADA ✅
```bash
$ curl -v "http://users-api.local/api/vulnerable/search?q=admin' OR '1'='1"
< HTTP/1.1 403 Forbidden
< server: bunkerweb
{
  "success": false,
  "message": "⚠️ SQL Injection detectado!",
  "vulnerability": "SQL Injection"
}
```

### Requisição PERMITIDA ✅
```bash
$ curl http://users-api.local/api/users
< HTTP/1.1 200 OK
{
  "success": true,
  "data": [...]
}
```

---

## 🛠️ Troubleshooting

### WAF não está bloqueando?

1. Verificar se o BunkerWeb está rodando:
   ```bash
   kubectl get pods -l app=bunkerweb
   ```

2. Verificar se o ingress está usando o BunkerWeb:
   ```bash
   kubectl describe ingress demo-ingress-waf
   ```

3. Ver logs do WAF:
   ```bash
   kubectl logs -l app=bunkerweb --tail=100
   ```

### Erro de conexão?

1. Verificar /etc/hosts:
   ```bash
   cat /etc/hosts | grep ".local"
   ```

2. Deve conter:
   ```
   <MINIKUBE_IP> demo.local
   <MINIKUBE_IP> users-api.local
   <MINIKUBE_IP> products-api.local
   ```

3. Se não tiver, adicionar:
   ```bash
   MINIKUBE_IP=$(minikube ip)
   sudo bash -c "echo \"$MINIKUBE_IP demo.local\" >> /etc/hosts"
   sudo bash -c "echo \"$MINIKUBE_IP users-api.local\" >> /etc/hosts"
   sudo bash -c "echo \"$MINIKUBE_IP products-api.local\" >> /etc/hosts"
   ```

---

## 📚 Próximos Passos

1. ✅ Leia o [WAF-GUIDE.md](WAF-GUIDE.md) completo
2. ✅ Execute `./scripts/test-waf.sh` para testes completos
3. ✅ Execute `./scripts/attack-simulation.sh` para simulações avançadas
4. ✅ Analise os logs: `kubectl logs -l app=bunkerweb -f`
5. ✅ Experimente criar seus próprios payloads de ataque

---

**Happy Hacking! 🎓🛡️**


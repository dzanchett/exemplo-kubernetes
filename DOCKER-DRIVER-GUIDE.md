# 🐳 Guia para Driver Docker no macOS

## ⚠️ Limitações do Driver Docker

Seu Minikube está usando o **driver Docker**, que tem estas limitações no macOS:

### ❌ O que NÃO funciona:
- Ping ao IP do Minikube (192.168.49.2)
- `minikube tunnel` 
- Acesso via `/etc/hosts` (demo.local, users-api.local, etc.)
- Ingress tradicional

### ✅ O que FUNCIONA:
- `minikube service` - Cria túnel automático para localhost
- Port-forward direto (mas pula o WAF)
- Acesso via localhost com túnel

---

## 🚀 Como Testar o WAF (Driver Docker)

### Método 1: Usar os Scripts (Recomendado) ⭐

**Terminal 1 - Expor o WAF:**
```bash
cd scripts
./waf-expose.sh
```

Isso mostrará algo como:
```
http://127.0.0.1:51143   ← ANOTE ESTA PORTA!
http://127.0.0.1:51144
```

**⚠️ Deixe este terminal aberto!**

---

**Terminal 2 - Executar Testes Automatizados:**
```bash
cd scripts

# Definir a URL do WAF (use a porta que apareceu no Terminal 1)
export WAF_URL="http://127.0.0.1:51143"

# Executar todos os testes
./test-waf-docker.sh
```

Isso executará **30+ testes** automatizados e mostrará quais ataques foram bloqueados!

---

**Ou Testar Manualmente:**
```bash
# Use a porta que apareceu (exemplo: 51143)
export WAF_URL="http://127.0.0.1:51143"

# Teste básico - deve funcionar ✅
curl $WAF_URL/api/users

# SQL Injection - deve bloquear ❌
curl "$WAF_URL/api/vulnerable/search?q=admin' OR '1'='1"

# XSS - deve bloquear ❌
curl "$WAF_URL/api/vulnerable/comment?text=<script>alert('XSS')</script>"
```

---

### Método 2: Manual

**Terminal 1:**
```bash
minikube service bunkerweb-service -n demo-k8s
```

Anote a URL que aparecer (ex: `http://127.0.0.1:XXXXX`)

**Terminal 2:**
```bash
# Substitua PORTA pela porta que apareceu
curl http://127.0.0.1:PORTA/api/users
```

---

## 🧪 Testes Completos

Depois de expor o WAF com `./waf-expose.sh`:

### SQL Injection
```bash
# Substitua 51143 pela sua porta
BASE="http://127.0.0.1:51143"

# Deve funcionar ✅
curl "$BASE/api/users"

# Deve bloquear ❌ (HTTP 403)
curl "$BASE/api/vulnerable/search?q=admin' OR '1'='1"
curl "$BASE/api/vulnerable/search?q=1' UNION SELECT password FROM users--"
```

### XSS
```bash
# Deve bloquear ❌
curl "$BASE/api/vulnerable/comment?text=<script>alert('XSS')</script>"
curl "$BASE/api/vulnerable/comment?text=<img src=x onerror=alert(1)>"
```

### Path Traversal
```bash
# Deve bloquear ❌
curl "$BASE/api/vulnerable/file?name=../../etc/passwd"
```

### Command Injection
```bash
# Deve bloquear ❌
curl "$BASE/api/vulnerable/ping?host=localhost;cat /etc/passwd"
```

---

## 📊 Verificar Logs do WAF

```bash
kubectl logs -l app=bunkerweb -n demo-k8s -f
```

---

## 🔄 Alternativa: Mudar para HyperKit

Se quiser usar o método tradicional (com `/etc/hosts` e `minikube tunnel`):

### 1. Instalar HyperKit
```bash
brew install hyperkit
```

### 2. Recriar o cluster
```bash
# Parar o cluster atual
minikube stop

# Deletar (ATENÇÃO: isso remove tudo!)
minikube delete

# Criar com HyperKit
minikube start --driver=hyperkit --cpus=4 --memory=4096

# Rebuild do projeto
cd scripts
./setup.sh
```

### 3. Depois disso, funcionará:
```bash
# Tunnel funcionará
sudo minikube tunnel

# Em outro terminal
curl http://users-api.local/api/users
./scripts/test-waf.sh  # Funcionará normalmente
```

---

## 📝 Resumo Rápido

### Com Driver Docker (Atual):
```bash
# Terminal 1
./scripts/waf-expose.sh

# Terminal 2
curl http://127.0.0.1:PORTA/api/users
```

### Com HyperKit (Após migrar):
```bash
# Terminal 1
sudo minikube tunnel

# Terminal 2
curl http://users-api.local/api/users
./scripts/test-waf.sh
```

---

## ❓ FAQ

**P: Por que o ping não funciona?**  
R: O driver Docker usa rede bridge interna. É normal e esperado.

**P: Posso usar o driver Docker em produção?**  
R: Para testes locais, sim. Para produção, use clusters reais (GKE, EKS, AKS, etc.)

**P: O WAF funciona igual com Docker driver?**  
R: Sim! O WAF funciona perfeitamente, apenas o acesso é diferente.

**P: Preciso mudar para HyperKit?**  
R: Não obrigatório, mas facilita os testes com os scripts originais.

---

**Versão:** 1.0  
**Última atualização:** 2024


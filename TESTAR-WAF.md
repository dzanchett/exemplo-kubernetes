# 🛡️ Como Testar o WAF - Guia Rápido

## ⚡ 3 Passos Simples

### Passo 1: Expor o WAF

**Abra um terminal e execute:**
```bash
cd /Users/diegozanchett/Documents/cursor/exemplo-kubernetes/scripts
./waf-expose.sh
```

**Você verá algo como:**
```
http://127.0.0.1:51143   ← ANOTE ESTA PORTA!
http://127.0.0.1:51144
```

**⚠️ IMPORTANTE: Deixe este terminal ABERTO!**

---

### Passo 2: Definir a Variável

**Abra um NOVO terminal e execute:**
```bash
# Substitua 51143 pela porta que apareceu no Passo 1
export WAF_URL="http://127.0.0.1:51143"
```

---

### Passo 3: Executar Testes

**No mesmo terminal do Passo 2:**
```bash
cd /Users/diegozanchett/Documents/cursor/exemplo-kubernetes/scripts
./test-waf-docker.sh
```

---

## ✅ O que Esperar

### Requisições Normais - Devem FUNCIONAR ✅
```bash
curl $WAF_URL/api/users
# HTTP 200 OK com lista de usuários
```

### Ataques - Devem ser BLOQUEADOS ❌
```bash
# SQL Injection
curl "$WAF_URL/api/vulnerable/search?q=admin' OR '1'='1"
# HTTP 403 Forbidden ← WAF bloqueou!

# XSS
curl "$WAF_URL/api/vulnerable/comment?text=<script>alert('XSS')</script>"
# HTTP 403 Forbidden ← WAF bloqueou!

# Path Traversal
curl "$WAF_URL/api/vulnerable/file?name=../../etc/passwd"
# HTTP 403 Forbidden ← WAF bloqueou!
```

---

## 🎯 Exemplo Completo

```bash
# Terminal 1 (deixar rodando)
cd scripts
./waf-expose.sh
# Apareceu: http://127.0.0.1:51143

# Terminal 2
export WAF_URL="http://127.0.0.1:51143"
cd scripts
./test-waf-docker.sh

# Resultado esperado:
# ✅ BLOQUEADO pelo WAF (HTTP 403) - SQL Injection
# ✅ BLOQUEADO pelo WAF (HTTP 403) - XSS
# ✅ BLOQUEADO pelo WAF (HTTP 403) - Path Traversal
# ...
```

---

## 📊 Ver Logs do WAF

**Em um terceiro terminal:**
```bash
kubectl logs -l app=bunkerweb -n demo-k8s -f
```

Você verá os ataques sendo bloqueados em tempo real!

---

## ❓ Problemas?

### "Variável WAF_URL não está definida"
```bash
# Defina novamente:
export WAF_URL="http://127.0.0.1:PORTA"
```

### "Não consegui conectar ao WAF"
- Verifique se `./waf-expose.sh` está rodando no outro terminal
- Use a porta correta que apareceu

### "Ataques passando (HTTP 200)"
- Verifique se está acessando através do WAF (WAF_URL)
- Veja os logs: `kubectl logs -l app=bunkerweb -n demo-k8s`

---

## 📚 Mais Informações

- **Guia Completo Driver Docker:** `DOCKER-DRIVER-GUIDE.md`
- **Guia Geral do WAF:** `WAF-GUIDE.md`
- **Troubleshooting:** `WAF-TROUBLESHOOTING.md`

---

**Versão:** 1.0  
**Última Atualização:** 2024

🎉 **Boa sorte com os testes!**


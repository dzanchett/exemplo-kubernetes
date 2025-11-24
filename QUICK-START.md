# 🚀 Quick Start - Acesso Rápido ao Sistema

## ✅ Sistema Funcionando

Todos os componentes estão deployados e funcionando:
- ✅ Backend Users API
- ✅ Backend Products API  
- ✅ Frontend Angular

---

## 🏠 Acessar o Sistema (Modo Simples)

### 1️⃣ Executar Port-Forward

```bash
cd /Users/diegozanchett/Documents/cursor/exemplo-kubernetes/scripts
./port-forward.sh
```

### 2️⃣ Acessar o Frontend

Abra seu navegador em:

```
http://localhost:8080
```

**Pronto!** O frontend vai carregar usuários e produtos automaticamente. 🎉

---

## 🧪 Testar APIs Diretamente

Com o port-forward rodando, você também pode testar as APIs diretamente:

```bash
# Users API
curl http://localhost:8081/api/health
curl http://localhost:8081/api/users

# Products API
curl http://localhost:8082/api/health
curl http://localhost:8082/api/products
```

---

## 📊 Ver Status do Cluster

```bash
cd /Users/diegozanchett/Documents/cursor/exemplo-kubernetes/scripts
./status.sh
```

---

## 🛑 Parar

Pressione `Ctrl+C` no terminal onde o port-forward está rodando.

---

## 🌐 Acesso via Ingress (Alternativa)

Se preferir acessar via domínios (demo.local), execute:

```bash
# Terminal 1 - Manter rodando
sudo minikube tunnel

# Terminal 2 - Acessar
open http://demo.local
```

**Nota**: O `/etc/hosts` já está configurado com os domínios.

---

**Desenvolvido para fins educacionais** 🎓




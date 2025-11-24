# 🛡️ BunkerWeb WAF - Demonstração de Segurança Web

## 🎯 Visão Geral

Este projeto foi expandido para incluir uma **demonstração completa e educacional** de um **Web Application Firewall (WAF)** usando [BunkerWeb](https://www.bunkerweb.io/).

### O que você vai aprender:
- ✅ Como funciona um WAF
- ✅ Proteção contra OWASP Top 10
- ✅ Tipos comuns de ataques web
- ✅ Como detectar e bloquear exploits
- ✅ Análise de logs de segurança
- ✅ Melhores práticas de segurança

---

## 🚀 Quick Start (3 comandos)

```bash
# 1. Setup completo (inclui WAF)
cd scripts && ./setup.sh

# 2. Testar proteções do WAF
./test-waf.sh

# 3. Ver logs do WAF
kubectl logs -l app=bunkerweb -n demo-k8s -f
```

---

## 📚 Documentação Disponível

| Documento | Descrição | Tempo |
|-----------|-----------|-------|
| **WAF-QUICKSTART.md** | Setup rápido e testes básicos | 5 min |
| **WAF-GUIDE.md** | Guia completo e detalhado | 30 min |
| **WAF-IMPLEMENTATION.md** | Resumo técnico da implementação | 10 min |
| **WAF-SUMMARY.md** | Resumo executivo | 5 min |
| **WAF-TROUBLESHOOTING.md** | Guia de solução de problemas | 10 min |

### 📖 Recomendação de Leitura

1. **Iniciante?** Comece com `WAF-QUICKSTART.md`
2. **Quer entender tudo?** Leia `WAF-GUIDE.md`
3. **Quer detalhes técnicos?** Veja `WAF-IMPLEMENTATION.md`
4. **Quer visão geral?** Consulte `WAF-SUMMARY.md`

---

## 🧪 Scripts de Teste

### 1. test-waf.sh - Testes Automatizados
Executa **30+ testes** de segurança:
```bash
./scripts/test-waf.sh
```

**Testa:**
- SQL Injection (4 variações)
- XSS (4 variações)
- Path Traversal (4 variações)
- Command Injection (4 variações)
- SSRF (4 variações)
- Outros ataques

### 2. attack-simulation.sh - Simulador Avançado
Menu interativo com opções:
```bash
./scripts/attack-simulation.sh
```

**Opções:**
1. SQL Injection massivo
2. XSS massivo
3. Brute Force
4. DDoS Simulation
5. Web Scanner
6. OWASP Top 10
7. Rate Limiting test
8. **Todos os ataques**

### 3. waf-manage.sh - Gerenciador do WAF
Gerencia e monitora o WAF:
```bash
./scripts/waf-manage.sh
```

**Funcionalidades:**
- Status do WAF
- Logs em tempo real
- Estatísticas de bloqueios
- Reiniciar WAF
- Habilitar/Desabilitar
- Ver configuração

---

## 🔒 Endpoints Vulneráveis (Para Testes)

⚠️ **Atenção:** Endpoints intencionalmente vulneráveis para demonstração educacional!

### Users API (users-api.local)

| Endpoint | Tipo de Vulnerabilidade |
|----------|------------------------|
| `/api/vulnerable/search` | SQL Injection |
| `/api/vulnerable/comment` | XSS |
| `/api/vulnerable/file` | Path Traversal |
| `/api/vulnerable/ping` | Command Injection |
| `/api/vulnerable/debug` | Information Disclosure |

### Products API (products-api.local)

| Endpoint | Tipo de Vulnerabilidade |
|----------|------------------------|
| `/api/vulnerable/search` | SQL Injection |
| `/api/vulnerable/import-xml` | XXE |
| `/api/vulnerable/fetch` | SSRF |
| `/api/vulnerable/update` | Mass Assignment |
| `/api/vulnerable/server-info` | Information Disclosure |

---

## 🎯 Exemplos Práticos

### Teste 1: Requisição Normal ✅

```bash
curl http://users-api.local/api/users
```

**Resultado:**
```json
{
  "success": true,
  "data": [...]
}
```
**Status:** HTTP 200 OK ✅

---

### Teste 2: SQL Injection ❌

```bash
curl "http://users-api.local/api/vulnerable/search?q=admin' OR '1'='1"
```

**Resultado:**
```json
{
  "success": false,
  "message": "⚠️ SQL Injection detectado!",
  "vulnerability": "SQL Injection"
}
```
**Status:** HTTP 403 Forbidden ❌ (Bloqueado pelo WAF!)

---

### Teste 3: XSS Attack ❌

```bash
curl "http://users-api.local/api/vulnerable/comment?text=<script>alert('XSS')</script>"
```

**Status:** HTTP 403 Forbidden ❌ (Bloqueado pelo WAF!)

---

### Teste 4: Rate Limiting ⚠️

```bash
# Enviar 50 requisições rápidas
for i in {1..50}; do curl http://users-api.local/api/users; done
```

**Resultado:**
- Primeiras 20 requisições: ✅ HTTP 200
- Seguintes: ❌ HTTP 429 (Too Many Requests)

---

## 🛡️ Proteções Implementadas

### ModSecurity + OWASP CRS
- ✅ SQL Injection
- ✅ Cross-Site Scripting (XSS)
- ✅ Path Traversal
- ✅ Command Injection
- ✅ XXE (XML External Entity)
- ✅ SSRF

### Rate Limiting
- ✅ 20 requisições/segundo
- ✅ Burst de até 40 requisições
- ✅ Ban temporário (24h)

### Bot Protection
- ✅ Detecção de scanners (Nikto, SQLMap, etc.)
- ✅ Cookie challenge
- ✅ User-Agent analysis

### Security Headers
- ✅ X-Frame-Options: SAMEORIGIN
- ✅ Remove Server/X-Powered-By
- ✅ CORS configurado

---

## 📊 Arquitetura

### Fluxo de Requisição COM WAF

```
┌─────────┐
│ Cliente │
└────┬────┘
     │
     ▼
┌──────────────────┐
│ Ingress (Nginx)  │
└────┬─────────────┘
     │
     ▼
┌────────────────────────────┐
│   🛡️ BunkerWeb WAF        │
│                            │
│  ✅ Analisa requisição     │
│  ✅ Detecta padrões        │
│  ✅ Bloqueia se malicioso  │
│  ✅ Loga tentativas        │
└────┬───────────────────────┘
     │
     ▼ (se segura)
┌──────────────────┐
│ Backend APIs     │
└──────────────────┘
```

---

## 📈 Monitoramento

### Logs em Tempo Real

```bash
kubectl logs -l app=bunkerweb -n demo-k8s -f
```

### Estatísticas

```bash
# Total de bloqueios
kubectl logs -l app=bunkerweb -n demo-k8s | grep -c " 403 "

# Top IPs bloqueados
kubectl logs -l app=bunkerweb -n demo-k8s | grep " 403 " | awk '{print $1}' | sort | uniq -c | sort -rn
```

### Usar o Gerenciador

```bash
./scripts/waf-manage.sh
# Escolher opção "3" para estatísticas
```

---

## 🎓 Casos de Uso

### 1. Aula de Segurança (60 min)

```bash
# Setup (10 min)
./scripts/setup.sh

# Demonstração (25 min)
./scripts/test-waf.sh          # Mostrar bloqueios
kubectl logs -l app=bunkerweb -n demo-k8s -f  # Logs ao vivo

# Hands-on (25 min)
./scripts/attack-simulation.sh # Alunos testarem
```

### 2. Workshop (120 min)

**Parte 1:** Teoria (30 min)
- Apresentar OWASP Top 10
- Explicar WAF
- Mostrar arquitetura

**Parte 2:** Setup (15 min)
- Executar setup
- Verificar pods

**Parte 3:** Testes (45 min)
- Executar test-waf.sh
- Executar attack-simulation.sh
- Analisar logs

**Parte 4:** Experimentos (30 min)
- Criar payloads customizados
- Comparar com/sem WAF
- Discussão

### 3. Autoestudo

1. Ler `WAF-QUICKSTART.md` (5 min)
2. Executar `setup.sh` (10 min)
3. Executar `test-waf.sh` (5 min)
4. Ler `WAF-GUIDE.md` (30 min)
5. Experimentar (30 min)

---

## ⚠️ Disclaimer Importante

### ✅ Use Para:
- Educação e treinamento
- Demonstrações
- Workshops
- Testes de conceito

### ❌ NUNCA:
- Use em produção sem ajustes
- Exponha endpoints `/vulnerable/*` publicamente
- Teste em sistemas sem autorização
- Confie apenas no WAF

### ✅ SEMPRE:
- Valide entrada no backend
- Use prepared statements
- Implemente autenticação forte
- Mantenha dependências atualizadas
- Use WAF como **primeira linha de defesa**

---

## 🔗 Links e Recursos

### BunkerWeb
- 🌐 [Website Oficial](https://www.bunkerweb.io/)
- 📚 [Documentação](https://docs.bunkerweb.io/)
- 💻 [GitHub](https://github.com/bunkerity/bunkerweb)

### OWASP
- 📊 [Top 10](https://owasp.org/www-project-top-ten/)
- 🧪 [WebGoat](https://owasp.org/www-project-webgoat/)
- 🛡️ [CRS](https://coreruleset.org/)

### Aprendizado
- 🎓 [PortSwigger Academy](https://portswigger.net/web-security)
- 💻 [HackTheBox](https://www.hackthebox.com/)
- 📖 [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)

---

## 📋 Checklist para Demonstração

- [ ] Minikube rodando
- [ ] Executar `./scripts/setup.sh`
- [ ] Verificar pods: `kubectl get pods -n demo-k8s`
- [ ] Verificar WAF: `kubectl get pods -l app=bunkerweb -n demo-k8s`
- [ ] Testar: `./scripts/test-waf.sh`
- [ ] Preparar logs: `kubectl logs -l app=bunkerweb -n demo-k8s -f`
- [ ] Testar manualmente alguns ataques
- [ ] Mostrar estatísticas: `./scripts/waf-manage.sh`

---

## 🎉 Pronto!

Você agora tem:
- ✅ WAF funcionando
- ✅ 30+ testes automatizados
- ✅ Scripts de simulação
- ✅ Documentação completa
- ✅ Endpoints para demonstração
- ✅ Logs detalhados

### Começar Agora:

```bash
cd scripts
./setup.sh        # Setup
./test-waf.sh     # Testar
./waf-manage.sh   # Gerenciar
```

---

## 🤝 Suporte

**Problemas?**
1. Consulte `WAF-TROUBLESHOOTING.md` - Guia completo de problemas
2. Consulte `WAF-GUIDE.md` - Seção Troubleshooting
3. Verifique logs: `kubectl logs -l app=bunkerweb -n demo-k8s`
4. Verifique pods: `kubectl get pods -n demo-k8s`

**Dúvidas sobre ataques?**
- Consulte `WAF-GUIDE.md` - Seção "Tipos de Ataques"

**Quer aprender mais?**
- Links na seção "Links e Recursos" acima

---

## 📞 Estrutura dos Arquivos

```
exemplo-kubernetes/
├── WAF-README.md              ← VOCÊ ESTÁ AQUI
├── WAF-QUICKSTART.md          ← Start aqui (iniciante)
├── WAF-GUIDE.md               ← Guia completo
├── WAF-IMPLEMENTATION.md      ← Detalhes técnicos
├── WAF-SUMMARY.md             ← Resumo executivo
├── WAF-TROUBLESHOOTING.md     ← Solução de problemas
│
├── k8s/
│   ├── bunkerweb-deployment.yaml
│   └── ingress-with-bunkerweb.yaml
│
└── scripts/
    ├── test-waf.sh
    ├── attack-simulation.sh
    └── waf-manage.sh
```

---

**🎓 Bons estudos e boa demonstração!**

*Desenvolvido para fins educacionais - Use com responsabilidade* 🛡️

---

**Versão:** 2.0.0 - WAF Implementation  
**Status:** ✅ Completo e Testado  
**Última Atualização:** 2024


# 🛡️ Guia do WAF BunkerWeb - Demonstração de Segurança

## 📋 Índice

1. [Introdução](#introdução)
2. [O que é um WAF?](#o-que-é-um-waf)
3. [Arquitetura com BunkerWeb](#arquitetura-com-bunkerweb)
4. [Tipos de Ataques Demonstrados](#tipos-de-ataques-demonstrados)
5. [Como Usar](#como-usar)
6. [Testes de Segurança](#testes-de-segurança)
7. [Análise de Logs](#análise-de-logs)
8. [Referências](#referências)

---

## 🎯 Introdução

Este projeto foi expandido para incluir uma demonstração educacional de **Web Application Firewall (WAF)** usando o [BunkerWeb](https://www.bunkerweb.io/), uma solução open-source de próxima geração.

O objetivo é demonstrar:
- ✅ Como um WAF protege aplicações web
- ✅ Tipos comuns de ataques web
- ✅ Como detectar e bloquear tentativas de exploração
- ✅ Boas práticas de segurança

> ⚠️ **ATENÇÃO**: Este projeto contém endpoints intencionalmente vulneráveis para fins educacionais. **NUNCA** implemente código assim em produção!

---

## 🔒 O que é um WAF?

Um **Web Application Firewall (WAF)** é uma camada de segurança que:

### Funcionalidades Principais

1. **Filtragem de Tráfego HTTP/HTTPS**
   - Analisa todas as requisições antes de chegarem à aplicação
   - Bloqueia requisições maliciosas baseadas em regras

2. **Proteção Contra OWASP Top 10**
   - SQL Injection
   - Cross-Site Scripting (XSS)
   - Cross-Site Request Forgery (CSRF)
   - Path Traversal
   - Command Injection
   - E muito mais...

3. **Proteção Contra Bots Maliciosos**
   - Detecta scanners automatizados (Nikto, SQLMap, etc.)
   - Bloqueia bots maliciosos
   - Rate limiting para prevenir DDoS

4. **Logging e Monitoramento**
   - Registra todas as tentativas de ataque
   - Fornece visibilidade sobre ameaças
   - Ajuda na conformidade (compliance)

### Por que usar BunkerWeb?

- ✅ **Open Source** - Código auditável e transparente
- ✅ **ModSecurity** - Engine de WAF battle-tested
- ✅ **OWASP CRS** - Core Rule Set mantido pela comunidade
- ✅ **Fácil Integração** - Funciona como reverse proxy
- ✅ **Kubernetes Native** - Deployment simplificado

---

## 🏗️ Arquitetura com BunkerWeb

### Antes (Sem WAF)

```
Internet → Ingress → Services → Pods
```

### Depois (Com WAF)

```
Internet → Ingress → BunkerWeb WAF → Services → Pods
                         ↓
                   [Bloqueia Ataques]
```

### Fluxo de Requisição

1. **Usuário** faz uma requisição (ex: `http://demo.local`)
2. **Ingress** do Kubernetes recebe e roteia para o BunkerWeb
3. **BunkerWeb** analisa a requisição:
   - ✅ Se segura → encaminha para o serviço
   - ❌ Se maliciosa → bloqueia e retorna 403/406
4. **Aplicação** recebe apenas tráfego validado

### Proteções Ativas

O BunkerWeb neste projeto está configurado com:

```yaml
✅ ModSecurity Engine (CRS 3.0)
✅ Bad Behavior Detection
✅ Rate Limiting (20 req/s)
✅ Anti-Bot Protection
✅ IP Whitelisting
✅ Security Headers
✅ CORS Configuration
```

---

## 🎭 Tipos de Ataques Demonstrados

### 1. SQL Injection

**O que é:** Injeção de código SQL malicioso em queries do banco de dados.

**Exemplo de Ataque:**
```bash
curl "http://users-api.local/api/vulnerable/search?q=admin' OR '1'='1"
```

**Como o WAF Protege:**
- Detecta padrões SQL conhecidos (`OR`, `UNION`, `SELECT`, etc.)
- Bloqueia caracteres especiais em contextos perigosos
- Retorna HTTP 403 Forbidden

**Impacto se não protegido:**
- 💀 Vazamento de dados
- 💀 Bypass de autenticação
- 💀 Modificação/destruição de dados

---

### 2. Cross-Site Scripting (XSS)

**O que é:** Injeção de scripts maliciosos que executam no navegador da vítima.

**Exemplo de Ataque:**
```bash
curl "http://users-api.local/api/vulnerable/comment?text=<script>alert('XSS')</script>"
```

**Como o WAF Protege:**
- Bloqueia tags HTML perigosas (`<script>`, `<iframe>`, etc.)
- Detecta event handlers (`onerror`, `onload`, etc.)
- Sanitiza entrada de usuários

**Impacto se não protegido:**
- 💀 Roubo de cookies/sessões
- 💀 Phishing
- 💀 Defacement do site

---

### 3. Path Traversal

**O que é:** Tentativa de acessar arquivos fora do diretório permitido.

**Exemplo de Ataque:**
```bash
curl "http://users-api.local/api/vulnerable/file?name=../../etc/passwd"
```

**Como o WAF Protege:**
- Bloqueia sequências `../`
- Detecta paths absolutos suspeitos
- Valida caracteres permitidos em nomes de arquivo

**Impacto se não protegido:**
- 💀 Leitura de arquivos sensíveis
- 💀 Exposição de código-fonte
- 💀 Acesso a credenciais

---

### 4. Command Injection

**O que é:** Execução de comandos do sistema através da aplicação.

**Exemplo de Ataque:**
```bash
curl "http://users-api.local/api/vulnerable/ping?host=localhost;cat%20/etc/passwd"
```

**Como o WAF Protege:**
- Bloqueia caracteres de encadeamento (`;`, `|`, `&`, etc.)
- Detecta comandos Unix/Windows comuns
- Valida entrada de comandos

**Impacto se não protegido:**
- 💀 Controle total do servidor
- 💀 Instalação de malware
- 💀 Vazamento de dados

---

### 5. Server-Side Request Forgery (SSRF)

**O que é:** Força o servidor a fazer requisições para recursos internos.

**Exemplo de Ataque:**
```bash
curl "http://products-api.local/api/vulnerable/fetch?url=http://localhost:8080/admin"
```

**Como o WAF Protege:**
- Bloqueia URLs para localhost/127.0.0.1
- Detecta IPs privados (10.x, 192.168.x, etc.)
- Valida protocolos permitidos

**Impacto se não protegido:**
- 💀 Acesso a serviços internos
- 💀 Port scanning interno
- 💀 Bypass de controles de acesso

---

### 6. DDoS / Rate Limiting

**O que é:** Sobrecarga do servidor com muitas requisições.

**Exemplo de Ataque:**
```bash
# 1000 requisições em poucos segundos
for i in {1..1000}; do
  curl http://users-api.local/api/users &
done
```

**Como o WAF Protege:**
- Rate limiting: 20 requisições/segundo
- Burst tolerance: até 40 requisições
- Ban temporário de IPs abusivos

**Impacto se não protegido:**
- 💀 Indisponibilidade do serviço
- 💀 Custos elevados de infraestrutura
- 💀 Experiência ruim para usuários legítimos

---

### 7. Scanners e Bots Maliciosos

**O que é:** Ferramentas automatizadas que procuram vulnerabilidades.

**Exemplo de Ataque:**
```bash
curl -H "User-Agent: Nikto/2.1.6" http://demo.local
curl -H "User-Agent: sqlmap/1.0" http://users-api.local
```

**Como o WAF Protege:**
- Detecta User-Agents conhecidos de scanners
- Bad Behavior Detection
- CAPTCHA/Cookie challenge quando suspeito

**Impacto se não protegido:**
- 💀 Descoberta de vulnerabilidades
- 💀 Mapeamento da infraestrutura
- 💀 Preparação para ataques direcionados

---

## 🚀 Como Usar

### 1. Setup Inicial

```bash
# Clonar o repositório
git clone <seu-repo>
cd exemplo-kubernetes

# Executar setup (inclui BunkerWeb)
cd scripts
./setup.sh
```

### 2. Verificar Deployment do WAF

```bash
# Verificar se o BunkerWeb está rodando
kubectl get pods -l app=bunkerweb

# Ver logs do WAF
kubectl logs -l app=bunkerweb -f

# Verificar service
kubectl get svc bunkerweb-service
```

### 3. Testar Proteções Básicas

```bash
# Teste simples - deve funcionar
curl http://users-api.local/api/users

# Teste de ataque - deve ser bloqueado (403)
curl "http://users-api.local/api/vulnerable/search?q=admin' OR '1'='1"
```

---

## 🧪 Testes de Segurança

### Script 1: Teste Básico do WAF

```bash
cd scripts
./test-waf.sh
```

**O que faz:**
- ✅ Testa 30+ tipos de ataques
- ✅ Verifica se o WAF está bloqueando
- ✅ Categoriza por tipo de ataque (SQL, XSS, etc.)
- ✅ Mostra resultados coloridos e formatados

**Saída esperada:**
```
🔍 Testando: SQL Injection - OR 1=1
   URL: http://users-api.local/api/vulnerable/search?q=admin' OR '1'='1
   ✅ BLOQUEADO pelo WAF (HTTP 403)
   O WAF está protegendo a aplicação!
```

---

### Script 2: Simulação Avançada

```bash
cd scripts
./attack-simulation.sh
```

**Opções disponíveis:**
1. SQL Injection - Ataque completo (10 payloads)
2. XSS - Cross-Site Scripting massivo
3. Brute Force - Tentativas de login
4. DDoS Simulation - Flood de requisições
5. Web Scanner - Simulação Nikto/Nmap
6. OWASP Top 10 - Teste completo
7. Rate Limiting - Teste de limites
8. Todos os ataques (demo completa)

**Exemplo de uso:**
```bash
$ ./attack-simulation.sh
Escolha uma opção [1-8]: 4

🚨 Iniciando DDoS Simulation...
   ⚠️  Enviando 100 requisições em 10 segundos...
   Requisições: 100 | Bloqueadas: 45
✅ DDoS Simulation concluído
```

---

### Testes Manuais com curl

#### SQL Injection

```bash
# Teste 1: OR 1=1
curl -v "http://users-api.local/api/vulnerable/search?q=admin' OR '1'='1"

# Teste 2: UNION SELECT
curl -v "http://users-api.local/api/vulnerable/search?q=1' UNION SELECT password FROM users--"

# Teste 3: DROP TABLE
curl -v "http://products-api.local/api/vulnerable/search?q='; DROP TABLE products;--"
```

#### Cross-Site Scripting (XSS)

```bash
# Teste 1: Script tag
curl -v "http://users-api.local/api/vulnerable/comment?text=<script>alert('XSS')</script>"

# Teste 2: Event handler
curl -v "http://users-api.local/api/vulnerable/comment?text=<img src=x onerror=alert('XSS')>"

# Teste 3: JavaScript protocol
curl -v "http://users-api.local/api/vulnerable/comment?text=<a href='javascript:alert(1)'>click</a>"
```

#### Path Traversal

```bash
# Teste 1: /etc/passwd
curl -v "http://users-api.local/api/vulnerable/file?name=../../etc/passwd"

# Teste 2: Encoded
curl -v "http://users-api.local/api/vulnerable/file?name=%2e%2e%2f%2e%2e%2fetc%2fpasswd"
```

#### Command Injection

```bash
# Teste 1: Semicolon
curl -v "http://users-api.local/api/vulnerable/ping?host=localhost;cat /etc/passwd"

# Teste 2: Pipe
curl -v "http://users-api.local/api/vulnerable/ping?host=localhost|whoami"
```

---

## 📊 Análise de Logs

### Ver Logs do BunkerWeb

```bash
# Logs em tempo real
kubectl logs -l app=bunkerweb -f

# Últimas 100 linhas
kubectl logs -l app=bunkerweb --tail=100

# Filtrar por ataques bloqueados
kubectl logs -l app=bunkerweb | grep "403\|406\|blocked"
```

### O que procurar nos logs

#### Requisição Bloqueada
```
[ModSecurity] Detected SQLi using libinjection: 'OR '1'='1
[ACCESS] 192.168.1.100 - "GET /vulnerable/search?q=admin' OR '1'='1" 403
```

#### Rate Limiting
```
[RATE_LIMIT] Client 192.168.1.100 exceeded rate limit: 25 req/s
[ACCESS] 192.168.1.100 - "GET /api/users" 429
```

#### Bot Detection
```
[ANTIBOT] Detected scanner: Nikto/2.1.6
[ACCESS] 192.168.1.100 - "GET /admin" 403
```

### Métricas do WAF

```bash
# Total de requisições bloqueadas
kubectl logs -l app=bunkerweb | grep -c "403"

# Tipos de ataques detectados
kubectl logs -l app=bunkerweb | grep "ModSecurity" | awk '{print $3}' | sort | uniq -c

# IPs mais bloqueados
kubectl logs -l app=bunkerweb | grep "403" | awk '{print $2}' | sort | uniq -c | sort -rn
```

---

## 🎓 Conceitos Educacionais

### OWASP Top 10 (2021)

Este projeto demonstra proteções contra:

| # | Vulnerabilidade | Endpoint Demo | Protegido? |
|---|----------------|---------------|------------|
| A01 | Broken Access Control | `/vulnerable/debug` | ⚠️ Parcial |
| A02 | Cryptographic Failures | N/A | ⚠️ Educacional |
| A03 | **Injection** | `/vulnerable/search` | ✅ Sim |
| A04 | Insecure Design | `/vulnerable/server-info` | ⚠️ Parcial |
| A05 | Security Misconfiguration | Headers | ✅ Sim |
| A06 | Vulnerable Components | N/A | ✅ Sim (CRS) |
| A07 | Authentication Failures | N/A | ✅ Rate Limit |
| A08 | Software Integrity | `/vulnerable/import-xml` | ✅ Sim (XXE) |
| A09 | Logging Failures | Logs BunkerWeb | ✅ Sim |
| A10 | **SSRF** | `/vulnerable/fetch` | ✅ Sim |

### Defesa em Profundidade (Defense in Depth)

```
Camada 1: WAF (BunkerWeb)           ← VOCÊ ESTÁ AQUI
    ↓
Camada 2: Validação na Aplicação    ← Backend APIs
    ↓
Camada 3: Prepared Statements       ← Database Layer
    ↓
Camada 4: Permissões Mínimas        ← Infrastructure
    ↓
Camada 5: Monitoramento             ← Logs & Alerts
```

**Lição importante:** O WAF é a primeira linha de defesa, mas não é a única!

---

## 🔧 Configuração do BunkerWeb

### Principais Configurações

O arquivo `k8s/bunkerweb-deployment.yaml` contém:

```yaml
# ModSecurity (WAF Engine)
USE_MODSECURITY: "yes"
USE_MODSECURITY_CRS: "yes"
MODSECURITY_CRS_VERSION: "3"

# Proteção contra Bots
USE_BAD_BEHAVIOR: "yes"
BAD_BEHAVIOR_THRESHOLD: "10"
BAD_BEHAVIOR_BAN_TIME: "86400"  # 24 horas

# Rate Limiting
USE_LIMIT_REQ: "yes"
LIMIT_REQ_RATE: "20r/s"         # 20 req/segundo
LIMIT_REQ_BURST: "40"           # até 40 em burst

# Anti-Bot
USE_ANTIBOT: "cookie"
ANTIBOT_URI: "/admin /login"

# Headers de Segurança
CUSTOM_HEADER: "X-Frame-Options: SAMEORIGIN"
REMOVE_HEADERS: "Server X-Powered-By"
```

### Ajustar Sensibilidade

**Modo Permissivo (aprendizado):**
```yaml
MODSECURITY_SEC_RULE_ENGINE: "DetectionOnly"
```

**Modo Proteção (produção):**
```yaml
MODSECURITY_SEC_RULE_ENGINE: "On"
```

---

## 📚 Referências

### Documentação

- [BunkerWeb Documentation](https://docs.bunkerweb.io/)
- [ModSecurity Reference Manual](https://github.com/SpiderLabs/ModSecurity/wiki)
- [OWASP ModSecurity CRS](https://coreruleset.org/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

### Ferramentas de Teste

- [OWASP ZAP](https://www.zaproxy.org/) - Security testing tool
- [Burp Suite](https://portswigger.net/burp) - Web security testing
- [SQLMap](https://sqlmap.org/) - SQL injection tool
- [Nikto](https://cirt.net/Nikto2) - Web server scanner

### Aprendizado

- [OWASP WebGoat](https://owasp.org/www-project-webgoat/) - Vulnerable app for learning
- [PortSwigger Academy](https://portswigger.net/web-security) - Free web security training
- [HackTheBox](https://www.hackthebox.com/) - Penetration testing labs

---

## ⚠️ Disclaimer

Este projeto contém **vulnerabilidades intencionais** para fins educacionais.

**NUNCA:**
- ❌ Use este código em produção
- ❌ Exponha os endpoints `/vulnerable/*` publicamente
- ❌ Desabilite o WAF sem entender as consequências
- ❌ Confie apenas no WAF para segurança

**SEMPRE:**
- ✅ Valide entrada no backend
- ✅ Use Prepared Statements para SQL
- ✅ Implemente autenticação forte
- ✅ Mantenha dependências atualizadas
- ✅ Monitore logs de segurança
- ✅ Faça pentests regulares

---

## 🎯 Próximos Passos

1. **Execute os testes:**
   ```bash
   ./scripts/test-waf.sh
   ./scripts/attack-simulation.sh
   ```

2. **Analise os logs:**
   ```bash
   kubectl logs -l app=bunkerweb -f
   ```

3. **Experimente:**
   - Tente criar seus próprios payloads
   - Ajuste as configurações do WAF
   - Compare com/sem WAF

4. **Aprenda mais:**
   - Estude OWASP Top 10
   - Pratique no OWASP WebGoat
   - Leia sobre ModSecurity CRS

---

**Happy Learning! 🎓🛡️**

*Este projeto foi criado para fins educacionais. Use com responsabilidade.*


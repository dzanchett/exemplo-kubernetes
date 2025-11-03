# ?? Guia para Demonstra??o em Aula

Este guia auxilia o professor na apresenta??o do projeto em aula.

## ?? Prepara??o Pr?-Aula

### 1 Dia Antes

- [ ] Teste todo o setup em seu Mac
- [ ] Verifique se todas as URLs est?o acess?veis
- [ ] Prepare slides explicando conceitos (opcional)
- [ ] Teste proje??o/compartilhamento de tela

### No Dia

- [ ] Abra os terminals necess?rios
- [ ] Inicie o Minikube antecipadamente
- [ ] Teste acesso ?s URLs
- [ ] Tenha backup: screenshots ou v?deo

## ?? Roteiro de Demonstra??o (45-60 min)

### Parte 1: Introdu??o (5 min)

**Conceitos a cobrir:**
- O que ? Kubernetes?
- Por que usar containers?
- O que ? Minikube?
- Arquitetura de microservi?os

**Mostrar:**
- Diagrama de arquitetura (ARCHITECTURE.md)
- Estrutura de pastas do projeto

### Parte 2: Demonstra??o do Sistema (10 min)

**1. Mostrar o Frontend**
```bash
# No navegador
open http://demo.local
```

**Pontos a destacar:**
- Interface moderna e responsiva
- Integra??o com m?ltiplas APIs
- Comunica??o via HTTP

**2. Testar as APIs**
```bash
# Terminal
curl http://users-api.local/api/users | python3 -m json.tool
curl http://products-api.local/api/products | python3 -m json.tool
```

**Pontos a destacar:**
- APIs RESTful
- JSON responses
- Health checks

### Parte 3: Kubernetes na Pr?tica (20 min)

**1. Visualizar Recursos**
```bash
# Terminal 1
cd scripts
./status.sh
```

**Explicar:**
- Pods: Menor unidade no Kubernetes
- Services: Abstra??o para acesso
- Ingress: Roteamento externo
- Deployments: Gerenciamento de pods

**2. Ver Pods em Detalhe**
```bash
kubectl get pods -o wide
```

**Destacar:**
- M?ltiplas r?plicas (2 de cada)
- IPs internos
- Status (Running)
- Nodes

**3. Demonstrar Self-Healing**
```bash
# Deletar um pod
kubectl delete pod <nome-do-pod>

# Mostrar que Kubernetes recria automaticamente
watch kubectl get pods
```

**Explicar:** Kubernetes mant?m o estado desejado

**4. Logs em Tempo Real**
```bash
./logs.sh
# Escolher uma API
```

**Mostrar:**
- Logs centralizados
- Requests sendo processados

**5. Escalar Aplica??o**
```bash
# Escalar Users API para 5 r?plicas
kubectl scale deployment/users-api --replicas=5

# Ver mudan?a
kubectl get pods -w
```

**Explicar:**
- Escalabilidade horizontal
- Load balancing autom?tico
- Zero downtime

**6. Dashboard Visual**
```bash
minikube dashboard
```

**Mostrar:**
- Interface gr?fica do Kubernetes
- Visualiza??o de recursos
- M?tricas

### Parte 4: DevOps e CI/CD (10 min)

**1. Mostrar Dockerfiles**
```bash
# Mostrar Dockerfile do Frontend
cat frontend/Dockerfile
```

**Explicar:**
- Multi-stage builds
- Otimiza??o de imagens
- Boas pr?ticas

**2. Rebuild e Deploy**
```bash
./rebuild.sh
# Escolher uma aplica??o
```

**Explicar:**
- Build de imagens
- Rolling update
- Monitoramento do deploy

**3. Mostrar Manifestos K8s**
```bash
cat k8s/users-api-deployment.yaml
```

**Explicar:**
- Configura??o declarativa
- Resources limits
- Health checks (probes)

### Parte 5: Q&A e Exerc?cios (10-15 min)

**Exerc?cios Sugeridos:**

1. **Modificar n?mero de r?plicas**
   ```bash
   # Editar k8s/products-api-deployment.yaml
   # Mudar replicas de 2 para 3
   kubectl apply -f k8s/products-api-deployment.yaml
   ```

2. **Adicionar novo endpoint**
   - Modificar ProductController.php
   - Rebuildar imagem
   - Testar novo endpoint

3. **Ver m?tricas de recursos**
   ```bash
   kubectl top pods
   kubectl top nodes
   ```

## ?? Dicas para Apresenta??o

### Terminal

**Configura??o recomendada:**
- Fonte grande (18-20pt)
- Tema de alto contraste
- Dividir tela: terminal + navegador

**Ferramentas ?teis:**
```bash
# Watch cont?nuo
watch kubectl get pods

# Logs coloridos
stern users-api

# Dashboard
k9s
```

### Poss?veis Problemas

**Pod n?o inicia:**
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

**URL n?o funciona:**
```bash
# Verificar Ingress
kubectl get ingress
kubectl describe ingress demo-ingress

# Testar DNS
ping demo.local
```

**Imagem n?o encontrada:**
```bash
# Verificar se est? usando Docker do Minikube
eval $(minikube docker-env)
docker images
```

## ?? Pontos de Discuss?o

### 1. Containers vs VMs
- Mais leves
- Startup r?pido
- Isolamento
- Portabilidade

### 2. Monolito vs Microservi?os

**Monolito:**
- ? Simples
- ? Deploy ?nico
- ? Escala como um todo
- ? Deploy de tudo

**Microservi?os:**
- ? Escala independente
- ? Deploy independente
- ? Tecnologias espec?ficas
- ? Complexidade
- ? Overhead

### 3. Kubernetes em Produ??o

**Managed Services:**
- AWS EKS
- Google GKE
- Azure AKS
- DigitalOcean Kubernetes

**Self-Hosted:**
- Kubeadm
- Kops
- Rancher

### 4. Best Practices

**Seguran?a:**
- N?o rodar como root
- Usar secrets
- Network policies
- RBAC
- Image scanning

**Performance:**
- Resource limits
- Health checks
- Readiness probes
- HPA (Horizontal Pod Autoscaler)

**Observabilidade:**
- Logs centralizados
- M?tricas (Prometheus)
- Tracing (Jaeger)
- Dashboards (Grafana)

## ?? Roteiro Alternativo (Demonstra??o R?pida - 20 min)

Para uma demo mais curta:

1. **Introdu??o (3 min)**
   - O que ? o projeto
   - Arquitetura high-level

2. **Demonstra??o (7 min)**
   - Mostrar frontend funcionando
   - Testar uma API via curl
   - Mostrar pods rodando

3. **Funcionalidades Kubernetes (7 min)**
   - Deletar pod e ver recria??o
   - Escalar deployment
   - Ver logs

4. **Q&A (3 min)**

## ?? Checklist Pr?-Demo

```bash
# 1. Minikube rodando
minikube status

# 2. Todas as aplica??es deployadas
kubectl get pods
# Todos devem estar "Running"

# 3. URLs acess?veis
curl -s http://demo.local | head -n 5
curl -s http://users-api.local/api/health
curl -s http://products-api.local/api/health

# 4. Dashboard acess?vel
minikube dashboard &

# 5. Metrics server funcionando
kubectl top nodes
```

## ?? Objetivos de Aprendizado

Ao final da aula, os alunos devem entender:

- [ ] O que s?o containers
- [ ] O que ? orquestra??o de containers
- [ ] Conceitos b?sicos de Kubernetes (Pod, Service, Deployment, Ingress)
- [ ] Como fazer deploy de aplica??es
- [ ] Como escalar aplica??es
- [ ] Self-healing e alta disponibilidade
- [ ] Diferen?a entre desenvolvimento local e produ??o

## ?? Material de Apoio

**Para os Alunos:**
- README.md principal
- QUICKSTART.md para pr?tica
- INSTALLATION.md para setup
- ARCHITECTURE.md para aprofundamento

**V?deos Recomendados:**
- [Kubernetes in 100 Seconds](https://www.youtube.com/watch?v=PziYflu8cB8)
- [Docker in 100 Seconds](https://www.youtube.com/watch?v=Gjnup-PuquQ)

**Documenta??o:**
- https://kubernetes.io/docs/tutorials/
- https://docker-curriculum.com/

## ?? Ap?s a Aula

**Disponibilizar:**
- C?digo no GitHub
- Slides (se houver)
- Grava??o da aula
- Lista de exerc?cios

**Exerc?cios para Casa:**
1. Adicionar nova API (ex: Orders)
2. Implementar persistent storage
3. Adicionar autentica??o JWT
4. Implementar HTTPS

## ?? Avalia??o

**Crit?rios sugeridos:**
- Compreens?o de conceitos
- Capacidade de fazer deploy
- Troubleshooting
- Modifica??o de configura??es

**Projeto Final Sugerido:**
- Criar sistema com 3+ microservi?os
- Deploy em Kubernetes
- CI/CD pipeline
- Documenta??o completa

---

**Boa aula!** ??

*D?vidas? Consulte a documenta??o ou abra uma issue.*

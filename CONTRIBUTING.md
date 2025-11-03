# ?? Contribuindo para o Projeto

Obrigado por considerar contribuir com este projeto educacional! Este documento fornece diretrizes para contribui??es.

## ?? Tipos de Contribui??es

Aceitamos os seguintes tipos de contribui??es:

### 1. Corre??es de Bugs ??
- Erros de c?digo
- Problemas de configura??o
- Bugs na documenta??o

### 2. Novas Features ?
- Novos microservi?os
- Melhorias na UI/UX
- Funcionalidades adicionais

### 3. Melhorias na Documenta??o ??
- Corre??es de typos
- Clarifica??es
- Novos exemplos
- Tradu??es

### 4. Otimiza??es ?
- Performance
- Seguran?a
- Resource usage

## ?? Como Contribuir

### 1. Fork o Reposit?rio

```bash
# Clone seu fork
git clone https://github.com/seu-usuario/projeto.git
cd projeto
```

### 2. Crie uma Branch

```bash
# Para features
git checkout -b feature/nome-da-feature

# Para fixes
git checkout -b fix/nome-do-fix

# Para documenta??o
git checkout -b docs/nome-da-doc
```

### 3. Fa?a suas Mudan?as

**C?digo:**
- Siga as conven??es existentes
- Adicione coment?rios quando necess?rio
- Mantenha compatibilidade

**Documenta??o:**
- Seja claro e conciso
- Inclua exemplos
- Verifique ortografia

### 4. Teste suas Mudan?as

```bash
# Execute o setup
./scripts/setup.sh

# Teste manualmente
# Acesse as URLs e verifique funcionamento

# Execute testes
./scripts/test-apis.sh
```

### 5. Commit suas Mudan?as

**Conven??o de Commits:**

```bash
# Features
git commit -m "feat: adiciona nova API de pedidos"

# Fixes
git commit -m "fix: corrige erro no health check"

# Docs
git commit -m "docs: atualiza guia de instala??o"

# Chore
git commit -m "chore: atualiza depend?ncias"

# Refactor
git commit -m "refactor: melhora estrutura do c?digo"
```

**Tipos de commit:**
- `feat`: Nova funcionalidade
- `fix`: Corre??o de bug
- `docs`: Documenta??o
- `style`: Formata??o
- `refactor`: Refatora??o
- `test`: Testes
- `chore`: Tarefas gerais

### 6. Push e Pull Request

```bash
# Push para seu fork
git push origin nome-da-sua-branch
```

No GitHub:
1. V? para o reposit?rio original
2. Clique em "New Pull Request"
3. Selecione sua branch
4. Preencha o template do PR

## ?? Template de Pull Request

```markdown
## Descri??o
[Descreva suas mudan?as]

## Tipo de Mudan?a
- [ ] Bug fix
- [ ] Nova feature
- [ ] Breaking change
- [ ] Documenta??o

## Como Testar
[Passos para testar suas mudan?as]

## Checklist
- [ ] C?digo testado localmente
- [ ] Documenta??o atualizada
- [ ] Commits seguem conven??o
- [ ] Sem conflitos com main
```

## ?? Guias de Estilo

### PHP/Laravel

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;

class ExampleController extends Controller
{
    /**
     * Descri??o do m?todo
     */
    public function index(): JsonResponse
    {
        // C?digo aqui
        return response()->json([
            'success' => true,
            'data' => []
        ]);
    }
}
```

**Conven??es:**
- PSR-12 coding standard
- Type hints em m?todos
- DocBlocks para documenta??o
- Camel case para m?todos
- Snake case para propriedades

### TypeScript/Angular

```typescript
import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-example',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div>
      <!-- Template aqui -->
    </div>
  `,
  styles: []
})
export class ExampleComponent implements OnInit {
  public data: any[] = [];

  constructor() {}

  ngOnInit(): void {
    this.loadData();
  }

  private loadData(): void {
    // C?digo aqui
  }
}
```

**Conven??es:**
- Camel case para vari?veis e m?todos
- Pascal case para classes
- Type hints sempre
- Standalone components
- Reactive patterns com RxJS

### YAML/Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example
  labels:
    app: example
spec:
  replicas: 2
  selector:
    matchLabels:
      app: example
  template:
    metadata:
      labels:
        app: example
    spec:
      containers:
      - name: example
        image: example:latest
        ports:
        - containerPort: 80
```

**Conven??es:**
- 2 espa?os de indenta??o
- Labels consistentes
- Resource limits definidos
- Health checks configurados

### Shell Scripts

```bash
#!/bin/bash

set -e  # Exit on error

# Cores
GREEN='\033[0;32m'
NC='\033[0m'

# Fun??o exemplo
function example() {
    local arg=$1
    echo -e "${GREEN}Executando...${NC}"
    # C?digo aqui
}

# Execu??o
example "parametro"
```

**Conven??es:**
- `set -e` para erro-handling
- Fun??es para reutiliza??o
- Coment?rios descritivos
- Mensagens coloridas para feedback

## ?? Testes

### Adicionar Testes

Se voc? adicionar nova funcionalidade, inclua testes:

**Laravel:**
```bash
# Criar teste
php artisan make:test ExampleTest

# Rodar testes
php artisan test
```

**Angular:**
```bash
# Rodar testes
npm test

# Rodar com coverage
npm run test:coverage
```

### Testes Manuais

1. Execute setup completo
2. Teste todas as funcionalidades afetadas
3. Verifique logs para erros
4. Teste em diferentes cen?rios

## ?? Documenta??o

### Atualize a Documenta??o

Se suas mudan?as afetam:

- **Instala??o**: Atualize `INSTALLATION.md`
- **Uso**: Atualize `README.md`
- **Arquitetura**: Atualize `ARCHITECTURE.md`
- **Demo**: Atualize `DEMO-GUIDE.md`

### Adicione Exemplos

Inclua exemplos pr?ticos de uso:

```bash
# Exemplo de comando
./scripts/example.sh --option value

# Sa?da esperada
? Sucesso!
```

## ? Issues

### Reportar Bugs

Use o template:

```markdown
**Descri??o do Bug**
[Descri??o clara]

**Como Reproduzir**
1. Passo 1
2. Passo 2
3. Veja o erro

**Comportamento Esperado**
[O que deveria acontecer]

**Screenshots**
[Se aplic?vel]

**Ambiente:**
- OS: [macOS 13.0]
- Minikube: [v1.30.0]
- Docker: [24.0.0]
```

### Solicitar Features

```markdown
**Funcionalidade Desejada**
[Descri??o clara]

**Por que ? ?til?**
[Justificativa]

**Implementa??o Sugerida**
[Se tiver ideia de como implementar]
```

## ?? Code Review

Sua PR ser? revisada considerando:

- [ ] Funciona corretamente
- [ ] Segue padr?es de c?digo
- [ ] Tem testes adequados
- [ ] Documenta??o atualizada
- [ ] N?o quebra funcionalidades existentes
- [ ] Performance n?o degradada

## ?? Reconhecimento

Contribuidores ser?o creditados no README.md!

## ?? Precisa de Ajuda?

- Abra uma Issue
- Entre em contato via email
- Participe das discuss?es

## ?? Licen?a

Ao contribuir, voc? concorda que suas contribui??es ser?o licenciadas sob a mesma licen?a do projeto (MIT).

---

**Obrigado por contribuir!** ??

*Toda contribui??o, grande ou pequena, ? valiosa para a comunidade.*

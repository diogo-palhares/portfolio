# portfolio · diogopalhares.com

Site pessoal (currículo, projetos e notas técnicas), estático, na AWS, com toda a infraestrutura em Terraform e deploy por GitHub Actions via OIDC.

## Arquitetura

```
Visitante ──HTTPS──▶ Route 53 ──▶ CloudFront (CDN + TLS/ACM + CloudFront Function + security headers)
                                      │  Origin Access Control
                                      ▼
                                S3 (bucket privado)

GitHub ──▶ GitHub Actions ──OIDC──▶ IAM Roles (infra / deploy)
            pipeline.yml:
            changes ─┬─ infra-lint ─┬─ infra-plan   (PR: plan comentado no PR)
                     │              └─ infra-apply  (main) ─┐
                     └─ site-build ─────────────────────────┴─ site-deploy (main)
```

| Pasta | Conteúdo |
|---|---|
| `site/` | Site em [Astro](https://astro.build). Guia de conteúdo em [`site/CONTEUDO.md`](site/CONTEUDO.md) |
| `infra/bootstrap/` | Roda **uma vez**, localmente: bucket do state, provedor OIDC, roles `infra`/`deploy` e variáveis do repositório no GitHub |
| `infra/main/` | S3, CloudFront, ACM, Route 53, CloudFront Function, security headers, AWS Budget e parâmetros SSM do pipeline |
| `.github/workflows/pipeline.yml` | Pipeline único: detecta o que mudou, aplica a infra e depois publica o site |

### Como o pipeline se encadeia

- O job `changes` compara o commit com a base e decide se roda infra, site ou os dois. Na execução manual e no primeiro push, roda tudo.
- `site-deploy` depende de `infra-apply`: roda depois de um apply bem-sucedido, ou direto quando a infra não mudou.
- O deploy lê o bucket e o ID da distribuição do **SSM Parameter Store** (`/portfolio/*`), gravados pelo Terraform. Nenhum valor precisa ser copiado à mão depois do apply.
- A role `deploy` só lê esses parâmetros, escreve no bucket do site e invalida o cache. A role `infra` só aceita tokens da `main` e de PRs deste repositório.

## Custo estimado

| Item | Custo |
|---|---|
| Domínio `.com` (Route 53) | ~US$ 15/ano |
| Hosted zone Route 53 | US$ 0,50/mês |
| S3 + CloudFront + ACM + SSM (standard) | ~US$ 0 (tráfego de portfólio fica no free tier) |

AWS Budget com alerta em 80% (real) e 100% (previsto) de US$ 5/mês.

## Pré-requisitos

- Node.js 22.12+ (recomendado: 24 LTS)
- Terraform 1.10+
- AWS CLI v2 autenticada com permissão de administrador
- GitHub CLI (`gh auth login`)
- Domínio registrado no Route 53 (a hosted zone é criada automaticamente)

## Setup (primeira vez)

### 1. Bootstrap (único passo manual)
Cria o bucket do state, o OIDC, as roles e as variáveis `TF_STATE_BUCKET`, `AWS_INFRA_ROLE_ARN`, `AWS_DEPLOY_ROLE_ARN` e `ALERT_EMAIL` no repositório.

PowerShell:
```powershell
$env:GITHUB_TOKEN = gh auth token
terraform -chdir=infra/bootstrap init
terraform -chdir=infra/bootstrap apply   # pede o alert_email
```

### 2. Push
```bash
git push -u origin main
```
O pipeline cria toda a infra principal (de 5 a 15 min no primeiro apply) e publica o site.

## Fluxo de trabalho

- **Infra:** branch → PR (lint, scan e `plan` comentado) → merge (`apply` e, se o site mudou, deploy).
- **Conteúdo:** alteração em `site/` → PR (build de validação) → merge (deploy + invalidação).
- **Manual:** *Actions → pipeline → Run workflow* roda tudo.

## Rodar a infra principal localmente (opcional)
```bash
terraform -chdir=infra/main init -backend-config="bucket=$(terraform -chdir=infra/bootstrap output -raw state_bucket)"
terraform -chdir=infra/main plan -var="alert_email=<seu e-mail>"
```

## Achados aceitos do checkov

O checkov roda em modo informativo (`soft_fail`). Alguns achados são aceitos por custo/escopo de um site pessoal estático: WAF, logs de acesso do S3/CloudFront, replicação entre regiões, criptografia com KMS gerenciada pelo cliente e origin failover. Podem ser habilitados depois, se fizer sentido.

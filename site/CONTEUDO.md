# Guia de conteúdo do site

Este arquivo orienta quem for preencher o conteúdo, seja você ou outra sessão do Claude.
Todo texto a ser escrito está marcado como `[PREENCHER: instrução]` ou `PREENCHER` (em links).
Para listar o que ainda falta:

```bash
npm run placeholders
```

Para ver o resultado localmente: `npm install` (só na primeira vez) e depois `npm run dev`. O site abre em http://localhost:4321.

## Onde fica cada conteúdo

| O quê | Arquivo | Aparece em |
|---|---|---|
| Nome, cargo, localização, resumo, disponibilidade | `src/data/perfil.ts` → `perfil` | Home, título das páginas, meta description |
| Links LinkedIn / GitHub / e-mail | `src/data/perfil.ts` → `perfil.links` | Home, rodapé, link do código em "Sobre este site" |
| Currículo em PDF | `public/curriculo.pdf` (adicionar o arquivo) | Botões "Baixar currículo" |
| Experiências profissionais | `src/data/perfil.ts` → `experiencias` | /experiencia |
| Competências agrupadas | `src/data/perfil.ts` → `competencias` | /experiencia |
| Formação | `src/data/perfil.ts` → `formacao` | /experiencia |
| Certificações (`[]` oculta a seção) | `src/data/perfil.ts` → `certificacoes` | /experiencia |
| Projetos / estudos de caso | `src/content/projetos/*.md` (um arquivo por projeto) | /projetos, home (os com `destaque: true`) |
| Frase de introdução dos projetos | `src/pages/projetos/index.astro` | /projetos |
| Chamada "Como este site funciona" | `src/pages/index.astro` | Home |
| Arquitetura, pipeline e custos do site | `src/pages/sobre-este-site.astro` | /sobre-este-site |
| Notas técnicas (opcional) | `src/content/notas/*.md` | /notas (o menu só mostra "Notas" quando há alguma publicada) |

## Regras de conteúdo

- **Tom:** direto, primeira pessoa, português. Frases curtas. Nada de "apaixonado por tecnologia".
- **Resultados > ferramentas:** sempre que possível, diga o impacto (tempo, custo, confiabilidade) e não só a lista de tecnologias.
- **Confidencialidade:** não cite dados internos, nomes de clientes ou números sigilosos dos empregadores. Generalize ("um e-commerce de grande porte").
- **Consistência:** cargos, datas e empresas devem bater com o LinkedIn e com o PDF.
- **Projetos:** de 2 a 4 bons cases valem mais que 10 rasos. O nome do arquivo `.md` vira a URL: use kebab-case (ex.: `migracao-eks.md`) e apague ou renomeie os `projeto-exemplo-*.md`.
- **Notas:** publique só o que não envelhece rápido. Deixe `rascunho: true` até estar pronta.
- **Imagens:** coloque em `public/img/` e referencie como `/img/arquivo.png`. Diagramas em PNG/SVG leves.
- **Sem fontes ou scripts externos:** a CSP do CloudFront só permite recursos do próprio domínio (`'self'`).

## Checklist antes de publicar

- [ ] `npm run placeholders` retorna 0 pendentes
- [ ] `public/curriculo.pdf` existe e está atualizado
- [ ] `npm run build` roda sem erros
- [ ] Links de LinkedIn, GitHub e e-mail testados
- [ ] Revisão ortográfica

import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

// Cada arquivo .md em src/content/projetos vira /projetos/<nome-do-arquivo>
const projetos = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/projetos' }),
  schema: z.object({
    titulo: z.string(),
    resumo: z.string(),
    stack: z.array(z.string()),
    ordem: z.number().default(99),
    destaque: z.boolean().default(false),
    repositorio: z.string().optional(),
    rascunho: z.boolean().default(false),
  }),
});

// Cada arquivo .md em src/content/notas vira /notas/<nome-do-arquivo>
const notas = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/notas' }),
  schema: z.object({
    titulo: z.string(),
    descricao: z.string(),
    data: z.coerce.date(),
    tags: z.array(z.string()).default([]),
    rascunho: z.boolean().default(false),
  }),
});

export const collections = { projetos, notas };

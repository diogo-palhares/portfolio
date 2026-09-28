// Lista todos os placeholders "[PREENCHER: ...]" / "PREENCHER" que ainda faltam.
// Uso: npm run placeholders
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));
const dirs = ['src', 'public'];
const exts = /\.(astro|ts|md|mdx|txt)$/;
let total = 0;

function walk(dir) {
  for (const name of readdirSync(dir)) {
    const path = join(dir, name);
    if (statSync(path).isDirectory()) walk(path);
    else if (exts.test(name)) {
      readFileSync(path, 'utf8').split('\n').forEach((line, i) => {
        if (line.includes('PREENCHER')) {
          total++;
          console.log(`${relative(root, path)}:${i + 1}  ${line.trim().slice(0, 140)}`);
        }
      });
    }
  }
}

dirs.forEach((d) => walk(join(root, d)));
console.log(`\n${total} placeholder(s) pendente(s).`);

import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://diogopalhares.com',
  // Gera /pagina/index.html; a CloudFront Function resolve o index
  build: { format: 'directory' },
});

// Dados de perfil e carreira exibidos no site (home e /experiencia).
// Substitua todo texto "[PREENCHER: ...]". Guia completo em site/CONTEUDO.md.

export interface Experiencia {
  empresa: string;
  cargo: string;
  periodo: string;
  local: string;
  descricao: string;
  destaques: string[];
  stack: string[];
}

export interface Formacao {
  instituicao: string;
  curso: string;
  periodo: string;
}

export interface Certificacao {
  nome: string;
  emissor: string;
  ano: string;
  url?: string;
}

export interface GrupoCompetencias {
  grupo: string;
  itens: string[];
}

export const perfil = {
  nome: '[PREENCHER: nome como deve aparecer no site]',
  cargo: '[PREENCHER: título profissional curto, ex.: "DevOps Engineer"]',
  localizacao: '[PREENCHER: cidade/UF e modelo de trabalho, ex.: "Cidade, UF · Remoto"]',
  resumo:
    '[PREENCHER: 2 a 3 frases de apresentação: o que faz, em que tipo de ambiente atua e o que entrega. Também é usada como meta description do site (ideal: até ~160 caracteres).]',
  disponibilidade:
    '[PREENCHER: frase curta sobre o que busca, ex.: "Aberto a oportunidades DevOps/SRE". Deixe "" para ocultar.]',
  links: {
    linkedin: 'https://www.linkedin.com/in/PREENCHER',
    github: 'https://github.com/PREENCHER',
    email: 'PREENCHER@exemplo.com',
  },
  // Coloque o PDF em site/public/curriculo.pdf
  cv: '/curriculo.pdf',
};

// Da mais recente para a mais antiga
export const experiencias: Experiencia[] = [
  {
    empresa: '[PREENCHER: empresa]',
    cargo: '[PREENCHER: cargo]',
    periodo: '[PREENCHER: ex.: "jan 2024 – atual"]',
    local: '[PREENCHER: cidade ou "Remoto"]',
    descricao: '[PREENCHER: 1 frase de contexto sobre a empresa/time e seu papel]',
    destaques: [
      '[PREENCHER: conquista com resultado mensurável, ex.: "reduzi o tempo de deploy de X para Y com ..."]',
      '[PREENCHER: outra conquista]',
      '[PREENCHER: outra conquista]',
    ],
    stack: ['[PREENCHER: tecnologia]', '[PREENCHER: tecnologia]'],
  },
  {
    empresa: '[PREENCHER: empresa anterior]',
    cargo: '[PREENCHER: cargo]',
    periodo: '[PREENCHER: período]',
    local: '[PREENCHER: local]',
    descricao: '[PREENCHER: contexto]',
    destaques: ['[PREENCHER: conquista]', '[PREENCHER: conquista]'],
    stack: ['[PREENCHER: tecnologia]'],
  },
];

// Agrupe por área; evite listas enormes e "barras de nível"
export const competencias: GrupoCompetencias[] = [
  { grupo: '[PREENCHER: ex.: "Cloud"]', itens: ['[PREENCHER]', '[PREENCHER]'] },
  { grupo: '[PREENCHER: ex.: "IaC e CI/CD"]', itens: ['[PREENCHER]', '[PREENCHER]'] },
  { grupo: '[PREENCHER: ex.: "Containers e orquestração"]', itens: ['[PREENCHER]', '[PREENCHER]'] },
  { grupo: '[PREENCHER: ex.: "Observabilidade"]', itens: ['[PREENCHER]', '[PREENCHER]'] },
];

export const formacao: Formacao[] = [
  {
    instituicao: '[PREENCHER: instituição]',
    curso: '[PREENCHER: curso/grau]',
    periodo: '[PREENCHER: período ou ano de conclusão]',
  },
];

// Deixe [] para ocultar a seção
export const certificacoes: Certificacao[] = [
  {
    nome: '[PREENCHER: nome da certificação]',
    emissor: '[PREENCHER: emissor, ex.: "AWS"]',
    ano: '[PREENCHER: ano]',
    url: '[PREENCHER: link de verificação (Credly etc.) ou remova a propriedade]',
  },
];

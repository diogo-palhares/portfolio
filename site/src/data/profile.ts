// Profile and career data rendered on the site (home and /experience).
// Replace every "[FILL: ...]" marker. Full guide in site/CONTENT.md.

export interface Experience {
  company: string;
  role: string;
  period: string;
  location: string;
  description: string;
  highlights: string[];
  stack: string[];
}

export interface Education {
  institution: string;
  degree: string;
  period: string;
}

export interface Certification {
  name: string;
  issuer: string;
  year: string;
  url?: string;
}

export interface SkillGroup {
  group: string;
  items: string[];
}

export const profile = {
  name: '[FILL: full name exactly as it should appear on the site; must match LinkedIn]',
  title: '[FILL: short professional title, e.g. "DevOps Engineer"; must match the LinkedIn headline role]',
  location: '[FILL: city, country and work model, e.g. "City, Brazil · Remote"]',
  summary:
    '[FILL: 2-3 sentence introduction: what you do, what kind of environments you work in and what you deliver. Also used as the site meta description, so aim for ~160 characters or fewer.]',
  availability:
    '[FILL: short status line, e.g. "Open to DevOps/SRE opportunities". Use "" to hide the badge.]',
  links: {
    linkedin: 'https://www.linkedin.com/in/FILL',
    github: 'https://github.com/FILL',
    email: 'FILL@example.com',
  },
  // Put the PDF at site/public/resume.pdf
  cv: '/resume.pdf',
};

// Most recent first. Add or remove entries as needed.
export const experiences: Experience[] = [
  {
    company: '[FILL: company name]',
    role: '[FILL: job title]',
    period: '[FILL: e.g. "Jan 2024 – Present"]',
    location: '[FILL: city or "Remote"]',
    description: '[FILL: one sentence of context about the company/team and your role in it]',
    highlights: [
      '[FILL: achievement with a measurable result, e.g. "Cut deploy time from X to Y by ..."]',
      '[FILL: another achievement]',
      '[FILL: another achievement]',
    ],
    stack: ['[FILL: technology]', '[FILL: technology]'],
  },
  {
    company: '[FILL: previous company]',
    role: '[FILL: job title]',
    period: '[FILL: period]',
    location: '[FILL: location]',
    description: '[FILL: context]',
    highlights: ['[FILL: achievement]', '[FILL: achievement]'],
    stack: ['[FILL: technology]'],
  },
];

// Group by area; avoid huge lists and "skill level" bars
export const skills: SkillGroup[] = [
  { group: '[FILL: e.g. "Cloud"]', items: ['[FILL]', '[FILL]'] },
  { group: '[FILL: e.g. "IaC & CI/CD"]', items: ['[FILL]', '[FILL]'] },
  { group: '[FILL: e.g. "Containers & orchestration"]', items: ['[FILL]', '[FILL]'] },
  { group: '[FILL: e.g. "Observability"]', items: ['[FILL]', '[FILL]'] },
];

export const education: Education[] = [
  {
    institution: '[FILL: institution]',
    degree: '[FILL: degree/program]',
    period: '[FILL: period or graduation year]',
  },
];

// Use [] to hide the section
export const certifications: Certification[] = [
  {
    name: '[FILL: certification name]',
    issuer: '[FILL: issuer, e.g. "AWS"]',
    year: '[FILL: year]',
    url: '[FILL: verification link (Credly etc.) or remove this property]',
  },
];

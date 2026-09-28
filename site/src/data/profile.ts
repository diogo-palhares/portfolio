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
  name: 'Diogo Palhares',
  title: 'DevOps Engineer',
  location: 'Belo Horizonte, Brazil',
  summary:
    'DevOps Engineer building and running AWS infrastructure with Terraform, Kubernetes (EKS) and CI/CD. I automate deployments, observability and security.',
  availability: 'Open to DevOps/SRE opportunities',
  links: {
    linkedin: 'https://www.linkedin.com/in/diogo-palhares',
    github: 'https://github.com/diogo-palhares',
    email: 'diogocampos3210@gmail.com',
  },
  // Put the PDF at site/public/resume.pdf
  cv: '/resume.pdf',
};

// Most recent first. Add or remove entries as needed.
export const experiences: Experience[] = [
  {
    company: 'CI&T',
    role: 'DevOps Engineer',
    period: 'Mar 2025 – Present',
    location: 'Belo Horizonte, Brazil',
    description:
      'I design, automate and operate AWS infrastructure: CI/CD, Infrastructure as Code, a Kubernetes-based observability platform and edge security.',
    highlights: [
      'Designed and maintained CI/CD pipelines with Azure DevOps Pipelines and Terraform to provision AWS infrastructure, cutting deployment time by ~47% and removing manual steps across multiple environments.',
      'Built and operated an observability platform on AWS EKS (Grafana, Prometheus, Loki, Kafka, Alloy, Fluent Bit), improving incident detection time and monitoring coverage of critical systems.',
      'Led the migration of the observability stack to another AWS region, rebuilding the EKS cluster and reducing downtime during failover scenarios.',
      'Implemented AWS WAF from scratch, with custom rules to mitigate common web threats (OWASP Top 10).',
      'Built Docker-based tooling, including Python sidecar containers for automation, log processing and custom metric collection.',
    ],
    stack: [
      'AWS',
      'Terraform',
      'Kubernetes (EKS)',
      'Azure DevOps Pipelines',
      'Docker',
      'Grafana',
      'Prometheus',
      'Loki',
      'Kafka',
      'AWS WAF',
      'Python',
    ],
  },
];

// Group by area; avoid huge lists and "skill level" bars
export const skills: SkillGroup[] = [
  { group: 'Cloud & IaC', items: ['AWS (EKS, WAF, multi-region)', 'Terraform'] },
  { group: 'Containers & orchestration', items: ['Kubernetes', 'Docker', 'Helm'] },
  { group: 'CI/CD', items: ['Azure DevOps Pipelines', 'GitHub Actions', 'Git'] },
  {
    group: 'Observability & security',
    items: ['Grafana', 'Prometheus', 'Loki', 'Kafka', 'Fluent Bit', 'Alloy', 'AWS WAF'],
  },
  { group: 'Systems & programming', items: ['Linux', 'Shell scripting', 'Python', 'C#', 'SQL', 'JavaScript'] },
  { group: 'Languages', items: ['Portuguese (native)', 'English (advanced)'] },
];

export const education: Education[] = [
  {
    institution: 'PUC Minas',
    degree: "Bachelor's in Information Systems",
    period: 'Feb 2023 – Dec 2026',
  },
  {
    institution: 'CEFET-MG',
    degree: 'Technical Degree in Electrical Engineering (integrated high school)',
    period: 'Feb 2019 – Dec 2022',
  },
];

// Use [] to hide the section
export const certifications: Certification[] = [
  {
    name: 'AWS Certified Cloud Practitioner',
    issuer: 'Amazon Web Services',
    year: '[FILL: year obtained]',
    url: '[FILL: Credly verification link or remove this property]',
  },
];

# Site content guide

This file tells whoever fills in the site content (the owner or another Claude session) where each piece goes and what it must look like.
Every piece of text to be written is marked as `[FILL: instruction]`, or `FILL` inside links. To list what is still pending:

```bash
npm run placeholders
```

To preview locally: `npm install` (first time only), then `npm run dev`. The site opens at http://localhost:4321.

## Language

**All site content is written in English**, including project case studies and notes. Use natural, professional English, not a literal translation from Portuguese.

## Sources of truth

Only write facts that come from these sources. **Never invent** companies, dates, numbers, certifications or achievements.

1. The owner's resume PDFs (ask the owner for the current version; they have "linear" and "parallel" layouts).
2. The owner's LinkedIn profile (for titles, dates and company names, which must match exactly).
3. This repository itself (for the "About this site" page: `infra/`, `.github/workflows/pipeline.yml`, root `README.md`).
4. The owner directly: when something is missing or ambiguous (project details, measurable results, links), **ask** instead of guessing. Leave the `[FILL: ...]` marker in place if the answer is not available yet.

## Where each piece of content lives

| What | File | Shown on |
|---|---|---|
| Name, title, location, summary, availability | `src/data/profile.ts` → `profile` | Home, page titles, meta description |
| LinkedIn / GitHub / email links | `src/data/profile.ts` → `profile.links` | Home, footer, source link on "About this site" |
| Resume PDF | `public/resume.pdf` (add the file; English version) | "Download resume" buttons |
| Work experience | `src/data/profile.ts` → `experiences` | /experience |
| Grouped skills | `src/data/profile.ts` → `skills` | /experience |
| Education | `src/data/profile.ts` → `education` | /experience |
| Certifications (`[]` hides the section) | `src/data/profile.ts` → `certifications` | /experience |
| Projects / case studies | `src/content/projects/*.md` (one file per project) | /projects, home (those with `featured: true`) |
| Projects intro sentence | `src/pages/projects/index.astro` | /projects |
| "How this site works" callout | `src/pages/index.astro` | Home |
| Architecture, pipeline and costs of the site | `src/pages/about-this-site.astro` | /about-this-site |
| Technical notes (optional) | `src/content/notes/*.md` | /notes (the "Notes" menu link only appears once one is published) |

## Content rules

- **Tone:** direct, first person, short sentences. No clichés like "passionate about technology".
- **Results over tools:** whenever possible, state the impact (time, cost, reliability), not just the list of technologies. Use numbers only if the source provides them.
- **Confidentiality:** do not mention internal data, client names or confidential figures from employers. Generalize ("a large e-commerce platform").
- **Consistency:** job titles, dates and companies must match LinkedIn and the PDF exactly.
- **Projects:** 2-4 strong case studies beat 10 shallow ones. The `.md` file name becomes the URL: use kebab-case (e.g. `eks-migration.md`) and delete or rename the `example-project-*.md` files. Keep the frontmatter fields defined in `src/content.config.ts`.
- **Notes:** only publish content that will not age quickly. Keep `draft: true` until ready. Delete `example-note.md` if unused.
- **Images:** place them in `public/img/` and reference them as `/img/file.png`. Keep diagrams light (PNG/SVG).
- **No external fonts or scripts:** the CloudFront CSP only allows same-origin resources (`'self'`).
- **Do not change** layout, styles, routes or infrastructure while filling content; only replace the `FILL` markers and add content files.

## Checklist before publishing

- [ ] `npm run placeholders` reports 0 pending
- [ ] `public/resume.pdf` exists and is up to date
- [ ] `npm run build` completes without errors
- [ ] LinkedIn, GitHub and email links tested
- [ ] Spelling and grammar reviewed

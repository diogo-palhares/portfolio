---
title: "This site: static hosting on AWS with Terraform and OIDC"
summary: "A personal site treated as a production system: private S3 behind CloudFront, two Terraform stacks and a single GitHub Actions pipeline with no stored AWS keys."
stack: ["AWS", "Terraform", "CloudFront", "S3", "Route 53", "GitHub Actions", "Astro"]
order: 1
featured: true
repository: "https://github.com/diogo-palhares/portfolio"
draft: false
---

## Context

I wanted a place to publish my resume, projects and notes, and I wanted the site itself to show how I work. So I built it the way I would build infrastructure for a team: everything in code, reviewed through pull requests and shipped by a pipeline.

## What I did

- **Static site on private storage.** The site is built with Astro and uploaded to a private S3 bucket. Only CloudFront can read it, through Origin Access Control, and the bucket policy denies any request without TLS.
- **Edge logic without servers.** A CloudFront Function redirects `www` to the apex domain and maps `/page/` to `/page/index.html`, which S3 behind OAC does not resolve on its own. A response headers policy adds HSTS, CSP, `X-Frame-Options` and `Referrer-Policy`.
- **Two Terraform stacks.** `bootstrap` runs once, locally: remote-state bucket (versioned, encrypted, native S3 locking), the GitHub OIDC provider, two IAM roles and the GitHub repository variables. `main` owns the bucket, CloudFront, ACM, Route 53, an AWS Budget and the SSM parameters the pipeline reads.
- **Keyless CI/CD.** GitHub Actions assumes AWS roles over OIDC, so no access keys live in GitHub. Role trust is pinned to the repository's immutable OIDC subject (owner and repository numeric IDs), so a repository recreated later with the same name cannot assume them.
- **Least privilege per job.** The `infra` role runs plan and apply. The `deploy` role can only read two SSM parameters, write to the site bucket and invalidate the cache.

## Architecture

```
Visitor ──HTTPS──▶ Route 53 ──▶ CloudFront (TLS/ACM, CloudFront Function, security headers)
                                    │  Origin Access Control
                                    ▼
                              S3 (private bucket)

GitHub ──▶ GitHub Actions ──OIDC──▶ IAM roles (infra / deploy)
```

The pipeline detects whether a change touches infrastructure, the site or both. Infrastructure changes go through `terraform fmt`, `validate`, `tflint` and `checkov`; on pull requests the plan is posted as a comment, and on `main` it is applied. The site deploy only runs after a successful apply (or when infra did not change), so even the very first push creates the infrastructure and then publishes the site.

## Results

- Reproducible from scratch: the only manual step is a one-time `bootstrap` apply.
- No long-lived AWS credentials anywhere.
- Hashed assets are cached for a year as immutable; HTML always revalidates, so a deploy is visible right after the invalidation.
- The running cost is essentially the domain and the hosted zone, with an AWS Budget alert as a safety net.

More details are on the [About this site](/about-this-site/) page.

---
title: "Terraform CI/CD for AWS environments"
summary: "Built and hardened Azure DevOps pipelines that provision AWS with Terraform, cutting deployment time by ~47% and closing a path for accidental production applies."
stack: ["Azure DevOps Pipelines", "Terraform", "AWS"]
order: 4
featured: false
draft: false
---

## Context

AWS infrastructure for several environments (dev, stage and production) is provisioned with Terraform through Azure DevOps pipelines. Deployments had manual steps and redundant stages, which made them slow, and some pipelines had safety gaps that were easy to miss.

## What I did

- **Removed manual steps and redundancy.** Designed and maintained the pipelines so infrastructure changes go from code to environment only through CI/CD. For example, static analysis moved to a parallel stage that runs only on pull requests, instead of running serially on every build, including merges to `main`.
- **Closed an accidental-production path.** A manual "override branch check" parameter, meant for testing changes in dev, was wired into every environment's stage, so a test run could reach a real `terraform apply` against production. After that case was found and fixed, I audited the other multi-environment pipelines for the same pattern, so only dev can apply from a non-main branch and stage and production always require a merge to `main`.
- **Moved infrastructure between repositories safely.** Took part in extracting several Terraform components into a new repository. The gate was a zero-change proof: for every component and workspace, `terraform plan` against the existing state had to report "No changes" before the new pipelines were allowed to apply.

## Results

- Deployment time reduced by about 47%, with no manual steps left in the flow.
- Stage and production can only change through a reviewed merge to `main`.
- Terraform code reorganized without touching any live resource.

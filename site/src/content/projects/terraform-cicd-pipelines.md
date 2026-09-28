---
title: "Terraform CI/CD for AWS environments"
summary: "Replaced manual provisioning steps with Azure DevOps pipelines running Terraform, cutting deployment time by ~47% across environments."
stack: ["Azure DevOps Pipelines", "Terraform", "AWS"]
order: 3
featured: true
draft: false
---

## Context

AWS infrastructure for multiple environments depended on manual steps to be provisioned and deployed, which made deployments slow and error-prone.

## What I did

- Designed and maintained CI/CD pipelines in Azure DevOps Pipelines that provision AWS infrastructure with Terraform.
- Removed the manual steps from the deployment flow across environments.

## Results

- Deployment time reduced by about 47%.
- Consistent, repeatable deployments with no manual steps.

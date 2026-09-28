---
title: "Rolling out AWS WAF without breaking production"
summary: "Took public ingestion endpoints from an allow-all web ACL to layered WAF protection, validating every rule in count mode before blocking."
stack: ["AWS WAF", "Terraform", "CloudWatch"]
order: 3
featured: true
draft: false
---

## Context

The platform exposes public endpoints that devices and customers use to send data. Those endpoints were getting a steady stream of attacks, mostly file enumeration. A web ACL existed, but it allowed everything by default and had no rules, so in practice there was no protection.

## What I did

- **Everything in Terraform.** The web ACL and its rules live in code next to the rest of the network infrastructure, so every change goes through review and the pipeline.
- **Application-specific rules first.** For the bulk upload service, requests without a correctly formatted Bearer token are rejected at the edge, and requests are rate limited per IP.
- **Managed rules in layers.** Added AWS managed rule groups for common OWASP Top 10 attacks such as SQL injection and XSS, then IP reputation filtering and bot control, then geographic restrictions and custom rules for the application.
- **Count mode before block mode.** Each new set of rules went out with the `count` action first. I watched what they matched, checked that legitimate traffic was not being caught, and only then switched them to `block`.

## Results

- Public endpoints went from no effective filtering to rate limiting, token validation and managed protection against common web attacks.
- Rules were switched to block only after count-mode monitoring confirmed that legitimate requests were allowed and malicious ones were matched.

## Lessons learned

- A WAF that blocks real users is worse than no WAF. Count mode turns rule tuning into an observable, low-risk step.
- Rolling out in phases makes it obvious which rule caused a problem when one does.

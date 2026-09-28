---
title: "Observability platform on AWS EKS"
summary: "Operated and evolved a Kubernetes-based logs and metrics platform: moved it to another AWS region, upgraded its core components and extended it to cover data pipelines."
stack: ["AWS EKS", "Kubernetes", "Terraform", "Grafana", "Prometheus", "Loki", "Alloy", "Fluent Bit", "Kafka", "Python"]
order: 2
featured: true
draft: false
---

## Context

At CI&T I work on the cloud infrastructure of an industrial IoT platform. Logs and metrics from cloud services and from edge devices in the field all land in an observability stack running on a dedicated EKS cluster: Prometheus for metrics, Loki for logs and Grafana on top. When something breaks, this is where the team looks first, so it has to stay up and stay current.

## What I did

- **Moved the stack to another AWS region.** The dev observability cluster had to move from `us-west-2` to `us-east-1` to cut infrastructure costs, without interrupting log ingestion from edge devices. Instead of moving it in place, the plan was to stand up a new stack in the target region, point dev and stage services at it, keep the old stack available for a while in case anyone needed its data, and only then tear it down.
- **Major version upgrades.** Kept the EKS clusters on supported Kubernetes versions and upgraded the stack itself: Loki 2.9 to 3.x (with breaking changes), Grafana 11 to 12, and Promtail, which is deprecated, replaced by Grafana Alloy. Changes went to a dedicated upgrade cluster first, then to each environment's cluster.
- **Extended coverage to data pipelines.** Deployed Alloy collectors for Kafka consumer lag and for the data warehouse ingestion jobs, exported managed Kafka broker and Kafka Connect logs to Loki, and built a top-level system-health dashboard that drills down into each component.
- **Custom collection where agents fell short.** Wrote Python sidecar containers for log processing and custom metrics.

## Results

- Faster incident detection and broader monitoring coverage across critical systems.
- A stack that runs current, supported versions of Kubernetes, Loki and Grafana instead of deprecated ones.
- Less downtime during failover scenarios after the regional migration, and a more resilient platform overall.

## Lessons learned

- Rebuilding next to the old system and switching traffic over is slower than migrating in place, but it gives you a rollback path for free.
- A throwaway cluster just for upgrades pays for itself the first time a breaking change shows up.

# Resume Builder – Kubernetes & Deployment Manifests

This repository contains the **Kubernetes & Helm configuration** used to deploy the **Resume Builder platform**.

It is the **deployment layer** of the project: it knows nothing about how to build the app itself, only **how to run it in a cluster** (locally on Docker Desktop / kind / Minikube, or on GKE in GCP).

---

## Related Repositories

This repo works together with three application repos:

- **Frontend**
  - React-based web UI for creating and managing resumes.

- **Resume API (Backend)**
  - Main business logic: resume generation, parsing, and API endpoints consumed by the frontend.

- **LLM / LLM Service**
  - FastAPI-based service that talks to an LLM and provides AI-assisted resume suggestions / chat.

- **Database**
  - MongoDB Atlas (or another managed MongoDB) used for persistence.
  - The Kubernetes workloads in this repo connect to MongoDB via environment variables / secrets (no database is actually deployed in-cluster here).

---

## What This Repo Contains

At a high level, this repo contains:

- **Helm charts** for each service:
  - `frontend-chart` – Deploys the Resume Builder frontend.
  - `resume-api-chart` – Deploys the .NET Resume API backend.
  - `llm-service-chart` – Deploys the LLM / chatbot backend.

- **Kubernetes base manifests** (if present):
  - Namespace definition (e.g., `resume` namespace).
  - Optional shared objects such as `Ingress`, `NetworkPolicy`, or `ConfigMap` that are not tightly coupled to a specific service.

- **Environment configuration**:
  - `values.yaml` files for each Helm chart with:
    - Container image (Artifact Registry path in GCP).
    - Replicas, resources, and probes.
    - Environment variables (including MongoDB connection string, API URLs, etc., usually wired via Kubernetes `Secret` / `ConfigMap`).

- **(Optional) CI/CD configuration**:
  - `.github/workflows/` (if present) can contain deployment pipelines that:
    - Use Docker / Buildpacks to build images in the app repos.
    - Push images to **GCP Artifact Registry**.
    - Run `helm upgrade --install` against the target Kubernetes cluster (e.g., GKE).

### Example Structure (simplified)

```bash
resume-builder-k8s
├── charts/
│   ├── frontend-chart/
│   ├── resume-api-chart/
│   └── llm-service-chart/
├── k8s/                 # namespace/ingress manifests
│   ├── namespace.yaml
│   └── ingress.yaml
├── terraform/           # infra provisioning (APIs, cluster, registries)
└── README.md
```

# homelab-v2

> Homelab (mostly) as a Code

## Overview

This is a monorepo for my homelab setup. It contains all the configuration files and scripts I use to manage my homelab. The goal is to have everything as code, so I can easily recreate my homelab from scratch if needed.

## Directory structure

```sh
📁 .github          # Few GH Actions, mostly linters
📁 ansible          # Ansible playbooks & roles
📁 docs             # Documentation, hosted at https://homelab.andrzejgor.ski/
📁 kubernetes       # Kubernetes manifests managed with ArgoCD
├─📁 apps           # Applications definitions (Helm charts/plain K8S manifests)
├─📁 clusters       # Cluster-specific overlays
└─📁 argocd         # ArgoCD app definitions
📁 terraform        # Terraform configurations
```

## License

[MIT](LICENSE) - © 2025 [Andrzej Górski](https://andrzejgor.ski)

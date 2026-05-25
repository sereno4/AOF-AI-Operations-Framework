# AOF Security Infrastructure as Code
# OpenTofu v1.9.1 + Kubernetes provider

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k3d-agent-wasm-cluster"
}

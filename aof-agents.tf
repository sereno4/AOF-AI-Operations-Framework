# NetworkPolicies para os agentes AOF
# Permite comunicação entre os 4 agentes

resource "kubernetes_network_policy_v1" "aof_agents_ingress" {
  metadata {
    name      = "aof-agents-allow"
    namespace = "default"
    labels = {
      "managed-by"  = "opentofu"
      "security"    = "zero-trust"
      "aof-project" = "true"
    }
  }

  spec {
    pod_selector {
      match_labels = {
        "aof-agent" = "true"
      }
    }
    policy_types = ["Ingress", "Egress"]

    ingress {
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "default"
          }
        }
      }
      ports {
        port     = "8001"
        protocol = "TCP"
      }
      ports {
        port     = "8003"
        protocol = "TCP"
      }
      ports {
        port     = "8004"
        protocol = "TCP"
      }
      ports {
        port     = "8005"
        protocol = "TCP"
      }
      ports {
        port     = "8006"
        protocol = "TCP"
      }
    }

    egress {
      to {
        ip_block {
          cidr = "0.0.0.0/0"
        }
      }
    }
  }
}

# Knative broker — allow acesso à API K8s (reduz alertas Falco)
resource "kubernetes_network_policy_v1" "knative_broker_api" {
  metadata {
    name      = "allow-broker-api-access"
    namespace = "knative-eventing"
    labels = {
      "managed-by"  = "opentofu"
      "security"    = "zero-trust"
    }
  }

  spec {
    pod_selector {
      match_labels = {
        "app" = "mt-broker-controller"
      }
    }
    policy_types = ["Egress"]

    egress {
      to {
        ip_block {
          cidr = "10.43.0.1/32"
        }
      }
      ports {
        port     = "443"
        protocol = "TCP"
      }
    }
  }
}

# Permitir DNS para todos os namespaces — obrigatório Zero Trust
# sem DNS nenhum serviço funciona

resource "kubernetes_network_policy_v1" "allow_dns_egress" {
  for_each = toset(var.zero_trust_namespaces)

  metadata {
    name      = "allow-dns-egress"
    namespace = each.value
    labels = {
      "managed-by"  = "opentofu"
      "security"    = "zero-trust"
      "aof-project" = "true"
    }
  }

  spec {
    pod_selector {}
    policy_types = ["Egress"]

    egress {
      to {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "kube-system"
          }
        }
      }
      ports {
        port     = "53"
        protocol = "UDP"
      }
      ports {
        port     = "53"
        protocol = "TCP"
      }
    }
  }
}

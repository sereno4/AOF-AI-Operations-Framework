# Zero Trust — deny-all em todos os namespaces
# Gerado pelo AOF Zero Trust Agent
# Importado de: kubectl get networkpolicy -A

locals {
  deny_all_namespaces = var.zero_trust_namespaces
}

resource "kubernetes_network_policy_v1" "deny_all" {
  for_each = toset(local.deny_all_namespaces)

  metadata {
    name      = "default-deny-all"
    namespace = each.value
    labels = {
      "managed-by"  = "opentofu"
      "security"    = "zero-trust"
      "aof-project" = "true"
    }
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]
  }
}

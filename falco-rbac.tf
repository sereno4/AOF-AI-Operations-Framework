# RBAC — restringir acesso ao API server
# Responde à recomendação do Zero Trust Agent

resource "kubernetes_cluster_role_v1" "falco_readonly" {
  metadata {
    name = "falco-readonly"
    labels = {
      "managed-by"  = "opentofu"
      "aof-project" = "true"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "nodes", "namespaces", "events"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "replicasets"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "falco_readonly_binding" {
  metadata {
    name = "falco-readonly-binding"
    labels = {
      "managed-by"  = "opentofu"
      "aof-project" = "true"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.falco_readonly.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "falco"
    namespace = "falco"
  }
}

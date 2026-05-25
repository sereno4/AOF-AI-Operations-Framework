output "zero_trust_summary" {
  description = "Resumo da infraestrutura Zero Trust"
  value = {
    cluster          = var.cluster_name
    namespaces_secured = length(var.zero_trust_namespaces)
    deny_all_policies  = length(var.zero_trust_namespaces)
    managed_by         = "opentofu"
  }
}

output "network_policies_count" {
  value = length(var.zero_trust_namespaces)
}

variable "cluster_name" {
  description = "Nome do cluster K8s"
  type        = string
  default     = "k3d-agent-wasm-cluster"
}

variable "zero_trust_namespaces" {
  description = "Namespaces que recebem deny-all por padrão"
  type        = list(string)
  default = [
    "default", "auth", "cert-manager", "cilium-secrets",
    "falco", "headlamp", "istio-system", "knative-eventing",
    "knative-serving", "kourier-system", "kube-public"
  ]
}

variable "falco_alert_threshold" {
  description = "Threshold de alertas críticos antes de escalar"
  type        = number
  default     = 10
}

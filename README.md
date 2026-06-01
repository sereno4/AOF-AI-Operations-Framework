

# AOF — AI Operations Framework— OpenTofu

> **Multi-agent security platform for Kubernetes** — 5 specialized A2A agents monitoring Falco + Cilium + Hubble in real-time, with LLM-as-judge evaluation, cost tracking, and all security infrastructure as code via OpenTofu.

[![Zero Trust Score](https://img.shields.io/badge/ZT_Score-95%2F100-brightgreen?style=flat-square)](./infrastructure)
[![Agents](https://img.shields.io/badge/Agents-5_online-blue?style=flat-square)](#agents)
[![OpenTofu](https://img.shields.io/badge/OpenTofu-1.9.1-purple?style=flat-square)](./infrastructure)
[![Python](https://img.shields.io/badge/Python-3.12-yellow?style=flat-square)](#stack)
[![Falco](https://img.shields.io/badge/Falco-0.43.1-orange?style=flat-square)](#stack)
[![Phoenix Arize](https://img.shields.io/badge/Phoenix_Arize-16.x-pink?style=flat-square)](#observability)

---

## What this is

AOF is a production-grade AI security operations platform built on Kubernetes. It combines **5 specialized agents** — each an A2A-compatible microservice — that continuously monitor your cluster using real data from Falco, Cilium, and Hubble, with full observability via Arize Phoenix and all infrastructure managed as code with OpenTofu.

**Before → After in one session:**

| Metric | Before | After |
|---|---|---|
| Zero Trust Score | 0/100 | **95/100** |
| NetworkPolicies | 0 | **26 (IaC managed)** |
| Falco alerts | 202 | **116 (↓42%)** |
| API violations | 75 | **21 (↓72%)** |
| Risk Level | CRITICAL | **LOW** |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    AOF Ecosystem                            │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │  SRE-FinOps  │  │   Security   │  │   Correlation    │  │
│  │   :8001      │  │    :8004     │  │     :8003        │  │
│  │ pods + cost  │  │ Falco + RBAC │  │  SRE + Security  │  │
│  └──────┬───────┘  └──────┬───────┘  └────────┬─────────┘  │
│         │                 │                   │             │
│         └─────────────────┴───────────────────┘             │
│                           │                                 │
│              ┌────────────┴──────────────┐                  │
│              │                           │                  │
│  ┌───────────▼──────┐  ┌────────────────▼──────────────┐   │
│  │   Zero Trust     │  │  Cilium Policy Generator       │   │
│  │     :8005        │  │         :8006                  │   │
│  │ Falco+Cilium+    │  │  Hubble flows → NetworkPolicy  │   │
│  │ Hubble → ZTScore │  │       via LLM                  │   │
│  └──────────────────┘  └───────────────────────────────┘   │
│                                                             │
│  ────────────────────────────────────────────────────────   │
│                                                             │
│  Falco 0.43.1   Cilium eBPF   Hubble relay   Phoenix Arize  │
│  OpenTofu IaC   BeeAI A2A     Groq LLM       OpenTelemetry  │
└─────────────────────────────────────────────────────────────┘
```

---

## Agents

### 🤖 SRE-FinOps Agent `:8001`
Monitors Kubernetes workloads and correlates operational issues with financial cost. Uses real `kubectl` data — pod restarts, resource usage, instance pricing — to surface actionable FinOps recommendations.

**Skills:** `list_problematic_pods`, `describe_pod`, `finops_analysis`, `pod_logs`

### 🛡️ Security Agent `:8004`
Integrates with Falco and Cilium to provide a security posture overview. Classifies alerts by severity, maps RBAC compliance, and correlates security findings with cost impact.

**Skills:** `security_overview`, `falco_alerts`, `correlate_security_finops`

### 🔗 Correlation Agent `:8003`
Cross-references data from SRE and Security agents to produce unified risk assessments with financial impact. Calculates total risk cost and optimization potential.

**Skills:** `full_correlation`, `risk_scoring`, `optimization_recommendations`

### 🔒 Zero Trust Agent `:8005`
Analyzes the cluster's Zero Trust posture in real-time using live Falco logs, Cilium NetworkPolicy audit, Hubble flow data, and workload security context. Produces a scored report with prioritized remediation steps.

**Skills:** `zero_trust_analysis`, `falco_alerts`, `network_audit`, `workload_security`

### 🌐 Cilium Policy Generator `:8006`
Observes real network flows from Hubble and uses an LLM to generate context-aware `NetworkPolicy` YAML for workloads that lack coverage — automatically applying Zero Trust principles based on observed traffic.

**Skills:** `generate_policies`, `analyze_flows`, `cluster_topology`

---

## Observability

All agents are instrumented with **Arize Phoenix** via OpenTelemetry:

- **Distributed tracing** — every agent call, tool invocation, and LLM request traced end-to-end
- **LLM-as-judge evals** — automated quality evaluation of agent responses using Groq as evaluator
- **Cost tracking** — per-query LLM cost with monthly projections (`$0.000179/query avg`, `~$5.38/month` at 1k queries/day)
- **Anomaly monitoring** — continuous monitoring with configurable thresholds for latency, cost, and error rate

```python
# Phoenix tracer — used by all agents
from phoenix_tracer import AgentTracer
tracer = AgentTracer("sre-finops-agent")

with tracer.trace_agent("sre", query) as span:
    with tracer.trace_tool("list_pods") as tool_span:
        result = list_pods()
```

Phoenix UI available at `http://localhost:6006`

---

## Infrastructure as Code

All security infrastructure managed via **OpenTofu**:

```
infrastructure/
├── main.tf          # Provider config (kubernetes ~> 2.35)
├── variables.tf     # Cluster config and namespace list
├── deny-all.tf      # deny-all NetworkPolicy for all namespaces
├── allow-dns.tf     # DNS egress allowance (Zero Trust requirement)
├── aof-agents.tf    # NetworkPolicy for AOF agent communication
├── falco-rbac.tf    # ClusterRole + Binding for Falco read access
└── outputs.tf       # Summary outputs
```

```bash
cd infrastructure
tofu init
tofu plan   # shows 26 resources
tofu apply  # creates NetworkPolicies + RBAC
```

**State:** 26 resources managed · git versioned · reproducible

---

## Stack

| Layer | Technology |
|---|---|
| Runtime security | Falco 0.43.1 + Falcosidekick |
| Network security | Cilium eBPF + Hubble relay |
| AI observability | Arize Phoenix 16.x |
| Infrastructure as Code | OpenTofu 1.9.1 |
| Agent framework | BeeAI Framework + A2A protocol |
| LLM | Groq llama-3.3-70b-versatile |
| Tracing | OpenTelemetry + OTLP HTTP |
| Kubernetes | k3d cluster (k3s) |
| Language | Python 3.12 |

---

## Quick Start

### Prerequisites

- Docker + kubectl configured
- k3d cluster with Cilium and Falco installed
- Groq API key (free at [console.groq.com](https://console.groq.com))
- Python 3.12 + pip

### Install

```bash
git clone https://github.com/sereno4/agent-wasm-saas
cd agent-wasm-saas

python3 -m venv .venv
source .venv/bin/activate
pip install beeai-framework[a2a] arize-phoenix-otel opentelemetry-exporter-otlp-proto-http

export GROQ_API_KEY="your_key_here"
./start-all.sh
```

### Verify

```bash
./test-all.sh
# Expected: 3/3 agents responding

# Zero Trust analysis
curl -s -X POST http://localhost:8005/ \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"message/send","params":{"message":{"messageId":"1","role":"user","parts":[{"kind":"text","text":"zero trust analysis completa"}]}}}' \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['result']['status']['message']['parts'][0]['text'])"
```

### Apply infrastructure

```bash
cd infrastructure
tofu init && tofu apply -auto-approve
# Creates 26 resources: NetworkPolicies + RBAC
```

---

## Key Design Decisions

**Why A2A protocol?** Each agent exposes a standard JSON-RPC endpoint following the Agent-to-Agent spec. This makes them composable — the Correlation Agent calls SRE and Security agents directly, and any external orchestrator can integrate without custom adapters.

**Why OpenTofu for NetworkPolicies?** Manual `kubectl apply` creates drift. With OpenTofu, every security configuration is versioned in git, reviewable via `tofu plan`, and reproducible from scratch. The state file proves what's actually deployed.

**Why LLM-as-judge?** Keyword-based evaluation misses semantic quality. Using Groq to evaluate Groq responses gives an independent signal — the evaluator can catch when an agent identifies the right pods but gives wrong recommendations, which keyword matching would score as correct.

**Why Groq over OpenAI?** Latency. SRE and Security agents need sub-3s response for operational use. Groq llama-3.3-70b delivers this at a fraction of the cost.

---

## Project Structure

```
agent-wasm-saas/
├── sre-agent/              # SRE-FinOps Agent (port 8001)
│   └── main.py
├── security-agent/         # Security Agent (port 8004)
│   └── security_agent.py
├── correlation-agent/      # Correlation Agent (port 8003)
│   └── correlation_agent.py
├── zero-trust-agent/       # Zero Trust Agent (port 8005)
│   └── zero_trust_agent.py
├── cilium-policy-agent/    # Cilium Policy Generator (port 8006)
│   └── policy_agent.py
├── infrastructure/         # OpenTofu IaC
│   ├── main.tf
│   ├── deny-all.tf
│   ├── allow-dns.tf
│   ├── aof-agents.tf
│   └── falco-rbac.tf
├── phoenix_tracer.py       # Shared Phoenix/OTEL tracer
├── sre_evals.py            # Phoenix Evals — LLM-as-judge
├── cost_tracker.py         # Per-query cost tracking
├── anomaly_monitor.py      # Continuous anomaly detection
├── orchestrator.py         # Multi-agent orchestrator CLI
├── start-all.sh            # Start all agents
└── test-all.sh             # Integration tests
```

---

## Results

Running against a real k3d cluster with Knative, Istio, cert-manager, and custom microservices:

- **Zero Trust Score: 95/100** — from 0 with no policies
- **26 NetworkPolicies** managing isolation across 11 namespaces
- **Falco alert reduction: 42%** — by distinguishing real threats from known false positives (cilium-cni, loopback)
- **API violation reduction: 72%** — from proper RBAC and network policy enforcement
- **LLM eval accuracy: 80%** — keyword and LLM-judge in agreement on 4/5 test queries
- **Cost: $0.000179/query average** — $5.38/month projected at 1k queries/day

---

## License

MIT

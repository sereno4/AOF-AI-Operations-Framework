AOF — AI Operations Framework
Multi-Agent Security Operations Platform for Kubernetes

AI-driven security operations combining Falco, Cilium, Hubble, OpenTofu, and LLM-powered agents for continuous Zero Trust assessment and automated remediation.









Overview

AOF is a multi-agent security platform designed for Kubernetes environments.

The platform continuously analyzes runtime activity, network flows, RBAC permissions, and infrastructure posture using specialized A2A agents that collaborate to generate actionable security insights.

All security controls are managed through OpenTofu, ensuring reproducibility, auditability, and infrastructure consistency.

Impact
Metric	Before	After
Zero Trust Score	0/100	95/100
Network Policies	0	26
Falco Alerts	202	116
API Violations	75	21
Risk Level	Critical	Low
Architecture
flowchart TB

    subgraph Kubernetes Cluster
        F[Falco Runtime Security]
        C[Cilium eBPF]
        H[Hubble Flows]
    end

    subgraph AOF Agents
        SRE[SRE-FinOps Agent]
        SEC[Security Agent]
        CORR[Correlation Agent]
        ZT[Zero Trust Agent]
        POL[Cilium Policy Generator]
    end

    subgraph AI Layer
        LLM[Groq LLM]
        PHX[Arize Phoenix]
    end

    subgraph IaC
        TF[OpenTofu]
    end

    F --> SEC
    C --> SEC
    H --> POL

    SRE --> CORR
    SEC --> CORR

    SEC --> ZT
    H --> ZT
    C --> ZT

    POL --> LLM

    CORR --> PHX
    ZT --> PHX
    POL --> PHX

    TF --> C
    TF --> F
Agent Ecosystem
SRE-FinOps Agent

Port: 8001

Monitors Kubernetes workloads and correlates operational issues with infrastructure cost.

Capabilities

Pod health analysis
Restart investigation
Resource consumption review
FinOps recommendations
Log inspection
Security Agent

Port: 8004

Aggregates Falco and Cilium findings to provide a consolidated security posture assessment.

Capabilities

Runtime threat analysis
RBAC auditing
Security trend reporting
Cost-aware risk evaluation
Correlation Agent

Port: 8003

Correlates operational and security signals into a unified risk model.

Capabilities

Risk scoring
Impact analysis
Optimization opportunities
Executive summaries
Zero Trust Agent

Port: 8005

Computes a continuous Zero Trust score using live cluster telemetry.

Inputs

Falco alerts
Cilium policies
Hubble flows
Workload security context
Cilium Policy Generator

Port: 8006

Generates Kubernetes NetworkPolicies from observed traffic patterns using LLM reasoning.

Outputs

Least-privilege policies
Namespace isolation
Service communication maps
Zero Trust recommendations
Observability

All agents are instrumented through OpenTelemetry and Arize Phoenix.

Features
Distributed tracing
LLM-as-Judge evaluations
Cost analytics
Latency monitoring
Failure tracking
Agent interaction graphs
Infrastructure as Code
infrastructure/
├── main.tf
├── variables.tf
├── deny-all.tf
├── allow-dns.tf
├── aof-agents.tf
├── falco-rbac.tf
└── outputs.tf
Apply Infrastructure
cd infrastructure

tofu init
tofu plan
tofu apply

Managed Resources:

Network Policies
RBAC
Namespace isolation
DNS controls
Agent communication policies
Technology Stack
Layer	Technology
Runtime Security	Falco
Network Security	Cilium + Hubble
AI Agents	BeeAI A2A
LLM	Groq Llama 3.3 70B
Observability	Arize Phoenix
IaC	OpenTofu
Tracing	OpenTelemetry
Runtime	Kubernetes (k3s)
Language	Python 3.12
Project Structure
agent-wasm-saas/

├── sre-agent/
├── security-agent/
├── correlation-agent/
├── zero-trust-agent/
├── cilium-policy-agent/

├── infrastructure/

├── phoenix_tracer.py
├── cost_tracker.py
├── anomaly_monitor.py

├── orchestrator.py

├── start-all.sh
└── test-all.sh
Results

Validated on a real Kubernetes environment running:

Knative
Istio
Cert-Manager
Custom Microservices
Achievements
Zero Trust Score: 95/100
26 NetworkPolicies deployed
42% Falco noise reduction
72% API violation reduction
Full IaC governance
End-to-end AI observability
Roadmap
Phase 1
Multi-agent orchestration
Zero Trust scoring
Phoenix observability
OpenTofu integration
Phase 2
Autonomous remediation
Stateful memory
Long-term risk analysis
Phase 3
Multi-cluster support
Policy marketplace
Security copilot dashboard
License

MIT License

Built with Kubernetes, eBPF, OpenTofu, Falco, Cilium and AI Agents.

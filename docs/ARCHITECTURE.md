# SMS Terraform Infrastructure Architecture

Comprehensive technical architecture documentation for the SMS Terraform infrastructure.

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Component Diagram](#component-diagram)
3. [Module Architecture](#module-architecture)
4. [Network Design](#network-design)
5. [Compute Architecture](#compute-architecture)
6. [Storage & Data](#storage--data)
7. [Security & Compliance](#security--compliance)
8. [High Availability](#high-availability)
9. [Disaster Recovery](#disaster-recovery)

---

## Architecture Overview

The SMS infrastructure follows a **modular, cloud-native design** with:
- **Multi-environment support**: DEV, QA, UAT, PROD
- **Hub-and-spoke networking**: Centralized VNet with peering
- **Container orchestration**: AKS for microservices
- **Serverless components**: Key Vault, Storage, Application Gateway
- **Enterprise security**: NSGs, Private Endpoints, RBAC
- **Observability**: Log Analytics, Application Insights

### Key Principles
```
┌─────────────────────────────────────────────────────────┐
│                   DESIGN PRINCIPLES                     │
├─────────────────────────────────────────────────────────┤
│ ✓ Infrastructure as Code (IaC)                         │
│ ✓ Modular & Reusable Components                        │
│ ✓ Environment Parity (DEV/QA/UAT/PROD)               │
│ ✓ Least Privilege Access                              │
│ ✓ Defense in Depth                                     │
│ ✓ Monitoring & Logging                                │
│ ✓ Automated Deployment                                │
│ ✓ State Management & Locking                          │
└─────────────────────────────────────────────────────────┘
```

---

## Component Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                       SUBSCRIPTION                         │
│  (11318a43-071d-4fda-b43a-bd719a191760)                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │            SMS RESOURCE GROUP (SMS-RG)              │  │
│  │                 Location: uksouth                   │  │
│  ├──────────────────────────────────────────────────────┤  │
│  │                                                      │  │
│  │  ┌──────────────────────────────────────────────┐  │  │
│  │  │          NETWORKING LAYER                   │  │  │
│  │  ├──────────────────────────────────────────────┤  │  │
│  │  │ Virtual Network: sms-net (10.0.0.0/16)     │  │  │
│  │  │ ┌────────────────────────────────────────┐  │  │  │
│  │  │ │ Subnets:                              │  │  │  │
│  │  │ ├────────────────────────────────────────┤  │  │  │
│  │  │ │ • appgw-subnet (10.0.1.0/24)          │  │  │  │
│  │  │ │   ├─ Application Gateway              │  │  │  │
│  │  │ │   └─ NSG: appgw-nsg                   │  │  │  │
│  │  │ │                                        │  │  │  │
│  │  │ │ • jumpbox-subnet (10.0.5.0/26)        │  │  │  │
│  │  │ │   ├─ VM: sms-jumpbox                  │  │  │  │
│  │  │ │   └─ NSG: jumpbox-nsg                 │  │  │  │
│  │  │ │                                        │  │  │  │
│  │  │ │ • aks-subnet (10.0.2.0/23)            │  │  │  │
│  │  │ │   ├─ AKS: sms-aks-dev-cluster         │  │  │  │
│  │  │ │   │  ├─ Node Pool: agentpool          │  │  │  │
│  │  │ │   │  ├─ Node Pool: userpool           │  │  │  │
│  │  │ │   │  └─ Node Pool: uipool             │  │  │  │
│  │  │ │   └─ NSG: aks-nsg                     │  │  │  │
│  │  │ │                                        │  │  │  │
│  │  │ │ • private-endpoints-subnet            │  │  │  │
│  │  │ │   (10.0.4.0/24)                       │  │  │  │
│  │  │ │   ├─ Private Endpoints                │  │  │  │
│  │  │ │   └─ NSG: private-endpoints-nsg       │  │  │  │
│  │  │ │                                        │  │  │  │
│  │  │ │ • ado-agents-subnet (10.0.20.0/24)   │  │  │  │
│  │  │ │   └─ NSG: ado-agent-nsg               │  │  │  │
│  │  │ └────────────────────────────────────────┘  │  │  │
│  │  │ VNet Peering: sms-nonprod-peering          │  │  │
│  │  └──────────────────────────────────────────────┘  │  │
│  │                                                      │  │
│  │  ┌──────────────────────────────────────────────┐  │  │
│  │  │        COMPUTE & CONTAINER LAYER            │  │  │
│  │  ├──────────────────────────────────────────────┤  │  │
│  │  │                                              │  │  │
│  │  │ AKS: sms-aks-dev-cluster                   │  │  │
│  │  │ ├─ Kubernetes Version: 1.34.6              │  │  │
│  │  │ ├─ SKU Tier: Standard                      │  │  │
│  │  │ ├─ Private Cluster: Enabled                │  │  │
│  │  │ ├─ RBAC: Azure AD integrated               │  │  │
│  │  │ ├─ Policy: Azure Policy enabled            │  │  │
│  │  │ └─ Monitoring: Log Analytics integration   │  │  │
│  │  │                                              │  │  │
│  │  │ VMs:                                         │  │  │
│  │  │ ├─ sms-jumpbox (Standard_B2s)              │  │  │
│  │  │ └─ SMS-Non-Prod-1 (Standard_B4ms)          │  │  │
│  │  │                                              │  │  │
│  │  │ Container Registry:                         │  │  │
│  │  │ └─ SMSACRDEV (Standard SKU)                │  │  │
│  │  │                                              │  │  │
│  │  └──────────────────────────────────────────────┘  │  │
│  │                                                      │  │
│  │  ┌──────────────────────────────────────────────┐  │  │
│  │  │          STORAGE & DATA LAYER               │  │  │
│  │  ├──────────────────────────────────────────────┤  │  │
│  │  │                                              │  │  │
│  │  │ Storage Accounts:                          │  │  │
│  │  │ ├─ smsblobstorageaccountdev                │  │  │
│  │  │ │  └─ Containers: app-data                 │  │  │
│  │  │ ├─ metastorageaccnonprod                  │  │  │
│  │  │ └─ satfstatemetacode (Terraform state)   │  │  │
│  │  │                                              │  │  │
│  │  └──────────────────────────────────────────────┘  │  │
│  │                                                      │  │
│  │  ┌──────────────────────────────────────────────┐  │  │
│  │  │         SECURITY & VAULT LAYER              │  │  │
│  │  ├──────────────────────────────────────────────┤  │  │
│  │  │                                              │  │  │
│  │  │ Key Vault: metacode-kyvlt-dev              │  │  │
│  │  │ ├─ SKU: Standard                           │  │  │
│  │  │ ├─ RBAC: Enabled                           │  │  │
│  │  │ ├─ Soft Delete: 90 days                    │  │  │
│  │  │ └─ Secrets: Application credentials        │  │  │
│  │  │                                              │  │  │
│  │  │ Private Endpoints:                          │  │  │
│  │  │ ├─ Key Vault PE                            │  │  │
│  │  │ ├─ Storage Account PE                      │  │  │
│  │  │ ├─ Redis PE                                │  │  │
│  │  │ └─ SQL PE                                  │  │  │
│  │  │                                              │  │  │
│  │  └──────────────────────────────────────────────┘  │  │
│  │                                                      │  │
│  │  ┌──────────────────────────────────────────────┐  │  │
│  │  │        MONITORING & COMPLIANCE              │  │  │
│  │  ├──────────────────────────────────────────────┤  │  │
│  │  │                                              │  │  │
│  │  │ Log Analytics Workspace:                   │  │  │
│  │  │ └─ DefaultWorkspace-...                     │  │  │
│  │  │                                              │  │  │
│  │  │ Diagnostics: Enabled on all resources      │  │  │
│  │  │ Alerts: Set for critical resources         │  │  │
│  │  │ Audit Logging: Enabled                     │  │  │
│  │  │                                              │  │  │
│  │  └──────────────────────────────────────────────┘  │  │
│  │                                                      │  │
│  │  ┌──────────────────────────────────────────────┐  │  │
│  │  │          DDOS PROTECTION                    │  │  │
│  │  ├──────────────────────────────────────────────┤  │  │
│  │  │                                              │  │  │
│  │  │ DDoS Protection Plan: DDosProtectionPlan   │  │  │
│  │  │ ├─ Applied to: Virtual Network             │  │  │
│  │  │ ├─ Layer: 3/4 (Network/Transport)          │  │  │
│  │  │ └─ Threat Mitigation: Enabled              │  │  │
│  │  │                                              │  │  │
│  │  └──────────────────────────────────────────────┘  │  │
│  │                                                      │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │    TERRAFORM BACKEND (terraform-backend RG)         │  │
│  ├──────────────────────────────────────────────────────┤  │
│  │                                                      │  │
│  │ Storage Account: smstertfstate                      │  │
│  │ ├─ Container: tfstate                              │  │
│  │ ├─ Blobs: dev.terraform.tfstate                    │  │
│  │ │          qa.terraform.tfstate                    │  │
│  │ ├─ Versioning: Enabled                             │  │
│  │ ├─ Soft Delete: 30 days                            │  │
│  │ └─ State Locking: Enabled                          │  │
│  │                                                      │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Module Architecture

### Module Dependency Graph

```
global/
├─ naming.tf        → Shared naming conventions
├─ tags.tf          → Shared tagging strategy
├─ variables.tf      → Global variables
└─ versions.tf       → Provider versions

modules/
├─ network/
│  ├─ Manages: VNets, Subnets, Peering
│  ├─ Dependencies: None
│  └─ Outputs: subnet_ids, vnet_id
│
├─ nsg/
│  ├─ Manages: NSGs, Security Rules
│  ├─ Dependencies: network (optional)
│  └─ Outputs: nsg_ids, rule_ids
│
├─ vm/
│  ├─ Manages: VMs, Disks, NICs, Extensions
│  ├─ Dependencies: network, nsg
│  └─ Outputs: vm_ids, nic_ids, principal_ids
│
├─ aks/
│  ├─ Manages: AKS Cluster, Node Pools
│  ├─ Dependencies: network, log_analytics
│  └─ Outputs: kube_config, endpoint_id
│
├─ acr/
│  ├─ Manages: Container Registry
│  ├─ Dependencies: None
│  └─ Outputs: login_server, id
│
├─ key_vault/
│  ├─ Manages: Key Vault, Secrets, Access Policies
│  ├─ Dependencies: None
│  └─ Outputs: id, vault_uri
│
├─ storage/
│  ├─ Manages: Storage Accounts, Containers, Shares
│  ├─ Dependencies: None
│  └─ Outputs: account_ids, endpoints
│
├─ application_gateway/
│  ├─ Manages: App Gateway, Rules, Backends
│  ├─ Dependencies: network
│  └─ Outputs: id, backend_pools
│
└─ [other modules]/

environments/
├─ dev/
│  ├─ main.tf        → Module instantiation
│  ├─ variables.tf    → Environment variables
│  ├─ outputs.tf      → Exported values
│  ├─ provider.tf     → Provider config
│  ├─ backend.tf      → State backend
│  ├─ locals.tf       → Local values
│  └─ terraform.tfvars → Environment values
│
└─ qa/
   └─ [same as dev]
```

---

## Network Design

### Network Topology

```
┌────────────────────────────────────────────────────────┐
│              VNet: sms-net (10.0.0.0/16)              │
├────────────────────────────────────────────────────────┤
│                                                        │
│  Service Endpoints:                                  │
│  • Microsoft.Sql                                     │
│  • Microsoft.Storage                                 │
│                                                        │
│  ┌──────────────────────────────────────────────┐   │
│  │  appgw-subnet (10.0.1.0/24)                │   │
│  │  Application Gateway                        │   │
│  │  NSG: appgw-nsg                             │   │
│  │  Rules: Allow HTTP(80), HTTPS(443)          │   │
│  └──────────────────────────────────────────────┘   │
│                                                        │
│  ┌──────────────────────────────────────────────┐   │
│  │  jumpbox-subnet (10.0.5.0/26)               │   │
│  │  Jumpbox VM                                  │   │
│  │  NSG: jumpbox-nsg                            │   │
│  │  Rules: Allow RDP(3389), SSH(22)            │   │
│  └──────────────────────────────────────────────┘   │
│                                                        │
│  ┌──────────────────────────────────────────────┐   │
│  │  aks-subnet (10.0.2.0/23)                   │   │
│  │  AKS Cluster                                 │   │
│  │  Node Pools: agentpool, userpool, uipool    │   │
│  │  NSG: aks-nsg                                │   │
│  │  Rules: Allow internal traffic              │   │
│  │  Service Endpoints: Microsoft.Sql           │   │
│  └──────────────────────────────────────────────┘   │
│                                                        │
│  ┌──────────────────────────────────────────────┐   │
│  │  private-endpoints-subnet (10.0.4.0/24)    │   │
│  │  Private Endpoints                          │   │
│  │  NSG: private-endpoints-nsg                 │   │
│  │  Rules: Allow HTTPS(443) from VNet          │   │
│  │  Service Endpoints: Microsoft.Sql           │   │
│  └──────────────────────────────────────────────┘   │
│                                                        │
│  ┌──────────────────────────────────────────────┐   │
│  │  ado-agents-subnet (10.0.20.0/24)           │   │
│  │  Azure DevOps Agents                        │   │
│  │  NSG: ado-agent-nsg                         │   │
│  │  Rules: Allow internal traffic              │   │
│  └──────────────────────────────────────────────┘   │
│                                                        │
│  Peerings:                                            │
│  • sms-nonprod-peering → vnet-uksouth                 │
│    - Bidirectional traffic allowed                   │
│    - Forwarded traffic enabled                       │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### NSG Rules Summary

| NSG | Inbound | Outbound |
|-----|---------|----------|
| appgw-nsg | HTTP(80), HTTPS(443) | All |
| jumpbox-nsg | RDP(3389), SSH(22) | All |
| aks-nsg | Internal(10.0.0.0/16) | All |
| private-endpoints-nsg | HTTPS(443) from VNet | All |
| ado-agent-nsg | Internal(10.0.0.0/16) | All |

---

## Compute Architecture

### AKS Configuration

```
Cluster: sms-aks-dev-cluster
├─ Version: 1.34.6
├─ Location: uksouth
├─ SKU Tier: Standard
├─ Private Cluster: Yes (private_cluster_enabled = true)
├─ Private DNS Zone: System-managed
├─ Network Plugin: Azure
├─ Network Policy: Azure
├─ Load Balancer: Standard
│
├─ RBAC & Security
│ ├─ RBAC: Enabled
│ ├─ Azure AD: Integrated
│ ├─ Workload Identity: Enabled
│ ├─ OIDC Issuer: Enabled
│ ├─ Azure Policy: Enabled
│ └─ Local Account: Disabled
│
├─ Node Pools
│ ├─ System Pool: agentpool
│ │  ├─ VM Size: Standard_D2as_v5 (AMD-based, cost-optimized)
│ │  ├─ Zones: 1, 2, 3 (Multi-AZ)
│ │  ├─ Min Nodes: 2
│ │  ├─ Max Nodes: 5
│ │  ├─ Max Pods: 30
│ │  └─ OS Disk: 128 GB
│ │
│ ├─ User Pool: userpool
│ │  ├─ VM Size: Standard_D2s_v5 (Intel-based)
│ │  ├─ Zones: 1, 2, 3
│ │  ├─ Min Nodes: 2
│ │  ├─ Max Nodes: 5
│ │  ├─ Max Pods: 19
│ │  └─ OS Disk: 128 GB
│ │
│ └─ Frontend Pool: uipool
│    ├─ VM Size: Standard_D2s_v5
│    ├─ Min Nodes: 3
│    ├─ Max Nodes: 5
│    ├─ Max Pods: 30
│    ├─ Node Labels: tier=frontend, workload=ui
│    ├─ Taints: workload=ui:NoSchedule
│    └─ OS Disk: 128 GB
│
├─ Service CIDR: 10.1.0.0/16
├─ DNS Service IP: 10.1.0.10
│
├─ Monitoring
│ └─ Log Analytics: DefaultWorkspace-...
│
└─ Auto-scaling
  ├─ Horizontal Pod Autoscaler: Enabled
  ├─ Cluster Autoscaler: Enabled
  └─ Update Strategy: Gradual
```

### Virtual Machines

```
VM: sms-jumpbox
├─ OS: Windows Server 2022
├─ Size: Standard_B2s (1 vCPU, 4 GB RAM)
├─ Subnet: jumpbox-subnet (10.0.5.0/26)
├─ Public IP: jumpbox-publicip (Static)
├─ Network Interface: sms-jumpbox757_z1
├─ Authentication: Username/Password
├─ NSG: jumpbox-nsg
└─ Purpose: Administrative access, cluster management

VM: SMS-Non-Prod-1
├─ OS: Windows Server 2022
├─ Size: Standard_B4ms (4 vCPU, 16 GB RAM)
├─ Subnet: aks-subnet (10.0.2.0/23)
├─ Public IP: None (Private)
├─ Network Interface: sms-non-prod-1539_z1
├─ Authentication: Username/Password
├─ NSG: SMS-Non-Prod-1-nsg
├─ Data Disks: 256 GB Premium_LRS
└─ Purpose: General-purpose compute workloads
```

---

## Storage & Data

### Storage Accounts

```
Storage Account: smsblobstorageaccountdev
├─ Tier: Standard
├─ Replication: GRS (Geo-Redundant)
├─ Access Tier: Hot
├─ Containers:
│  └─ app-data (Private access)
│     └─ Purpose: Application data storage
│
├─ Features:
│ ├─ HTTPS Only: Enabled
│ ├─ Minimum TLS: 1.2
│ ├─ Versioning: Enabled
│ ├─ Soft Delete: 30 days
│ └─ Blob Inventory: Enabled
│
└─ Network:
  └─ Public Network Access: Enabled
```

### Data Residency & Compliance

- **Region**: uksouth (UK South)
- **Data Replication**: GRS (Primary + Secondary)
- **Retention**: 30 days (soft delete)
- **Backup**: Enabled via storage versioning

---

## Security & Compliance

### Defense in Depth

```
Layer 1: Perimeter
├─ DDoS Protection: Enabled
├─ Application Gateway WAF: Available
└─ Public IP: Limited exposure

Layer 2: Network
├─ NSGs: All subnets protected
├─ Private Endpoints: For sensitive services
├─ VNet Service Endpoints: For Azure services
└─ Network Policies: Azure (AKS)

Layer 3: Identity & Access
├─ Azure AD: RBAC integration
├─ Service Principals: AKS identity
├─ Managed Identities: For Azure resources
├─ Key Vault: Secret management
└─ RBAC: Least privilege

Layer 4: Application
├─ Kubernetes RBAC: Pod security policies
├─ Network Policies: Kubernetes network policies
├─ Container Registry: Private access
└─ Image Scanning: Available

Layer 5: Data
├─ Encryption in Transit: HTTPS/TLS
├─ Encryption at Rest: Storage encryption
├─ Key Vault: Centralized key management
└─ Access Logs: Audit trail enabled
```

### Compliance & Tagging

```hcl
Tags Applied:
├─ Environment: dev/qa/uat/prod
├─ Application: SMS
├─ ManagedBy: Terraform
├─ CreatedDate: Automatically set
├─ CostCenter: For billing
├─ Owner: Team contact
├─ Compliance: Requirement tag
├─ BackupPolicy: Retention schedule
└─ MonitoringLevel: Basic/Standard/Enhanced/Critical
```

---

## High Availability

### Availability Strategies

**AKS**
- Multi-AZ deployment (Zones: 1, 2, 3)
- Multiple node pools for workload isolation
- Auto-scaling enabled (min: 2, max: 5 nodes)
- Managed disk replication

**VMs**
- Public IP for jumpbox: Static IP (manual failover)
- Internal VM: Managed via backup/recovery vault

**Storage**
- Geo-Redundant Storage (GRS)
- Blob versioning for data recovery
- Soft delete: 30-day retention

**Networking**
- Multiple subnets for isolation
- VNet peering for connectivity
- Service endpoints for Azure service access

---

## Disaster Recovery

### Backup Strategy

| Resource | Method | Frequency | Retention |
|----------|--------|-----------|-----------|
| AKS etcd | Automatic | Daily | 7 days |
| VMs | Azure Backup | Daily | 30 days |
| Storage | Versioning | Continuous | 30 days |
| Key Vault | Soft Delete | N/A | 90 days |
| State Files | Versioning | Per deploy | 30 days |

### Recovery Procedures

**AKS Cluster Recovery**
```bash
# Backup cluster configuration
kubectl get all -A > cluster-backup.yaml

# Restore from backup
kubectl apply -f cluster-backup.yaml
```

**VM Recovery**
```bash
# Via Azure Backup portal
# Time to recovery: ~15-30 minutes
```

**State Recovery**
```bash
# Restore from versioned storage
terraform state pull > recovery.json
# Or use backup from storage account versions
```

---

## Scaling Capabilities

### Horizontal Scaling

| Component | Current | Min | Max | Trigger |
|-----------|---------|-----|-----|---------|
| AKS Nodes | 2-3 | 2 | 5 | CPU > 80% |
| Pods | Variable | N/A | 30/node | HPA rules |
| Storage | N/A | N/A | Unlimited | On-demand |
| App Gateway | 2 | 1 | 10 | Autoscale rules |

### Vertical Scaling

```
Current VM Sizes:
├─ Jumpbox: Standard_B2s → can upgrade to Standard_D2s_v5
├─ App VM: Standard_B4ms → can upgrade to Standard_D4s_v5
└─ AKS Nodes: D2as/D2s → can upgrade to D4as/D4s
```

---

## Cost Optimization

### Resource-Level Optimization

```
AKS:
├─ Spot VMs: Available (reduces cost 70-90%)
├─ Reserved Instances: 1-year or 3-year options
└─ Auto-scaling: Prevents over-provisioning

Storage:
├─ Access Tier: Hot (automatic transition available)
├─ Redundancy: GRS (necessary for compliance)
└─ Lifecycle Policies: Archive old data

Networking:
├─ Load Balancer: Standard (required for production)
├─ Public IPs: Minimize usage
└─ Data Transfer: Keep internal where possible
```

---

## Deployment Workflow

### Change Management

```
┌─────────┐
│ Feature │
│ Branch  │
└────┬────┘
     │
     v
┌──────────────┐
│ Create PR    │ → Code Review
└──────┬───────┘
       │
       v
┌────────────────────────────┐
│ Run Automated Tests        │
├────────────────────────────┤
│ • terraform fmt            │
│ • terraform validate       │
│ • tflint                   │
│ • checkov (security)       │
└────────┬───────────────────┘
         │
         v
┌──────────────┐
│ Approve PR   │
└──────┬───────┘
       │
       v
┌────────────────┐
│ Merge to main  │
└────────┬───────┘
         │
         v
┌─────────────────────────────┐
│ Trigger Pipeline            │
├─────────────────────────────┤
│ ├─ Stage: Validate          │
│ ├─ Stage: Plan DEV          │
│ ├─ Stage: Approval (DEV)    │
│ ├─ Stage: Apply DEV         │
│ ├─ Stage: Plan QA           │
│ ├─ Stage: Approval (QA)     │
│ └─ Stage: Apply QA          │
└─────────────────────────────┘
```

---

## Maintenance Schedule

### Weekly
- Security updates review
- State backup verification
- Cost analysis

### Monthly
- Kubernetes version check
- Provider updates
- Compliance audit
- Disaster recovery test

### Quarterly
- Architecture review
- Capacity planning
- Performance tuning
- Security assessment

---

**Version**: 1.0.0  
**Last Updated**: May 2026  
**Maintained By**: SMS DevOps Team

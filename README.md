# Squidstack Terraform Infrastructure

Terraform infrastructure management for CloudBees Squidstack demo application.

## Purpose

This repository demonstrates CloudBees Unify orchestrating Terraform with comprehensive governance controls:
- **Git as Source of Truth**: Code checked out from version control
- **Security Scanning**: Checkov blocks insecure infrastructure
- **Policy Enforcement**: OPA validates compliance rules
- **Cost Governance**: Infracost prevents budget overruns
- **Full Audit Trail**: Complete evidence for compliance

Terraform executes on a bastion host with existing GCP credentials and network connectivity.

## Architecture

- **Git Repository**: Single source of truth for infrastructure code
- **CloudBees Unify**: Workflow orchestration, security checks, approval gates, audit trail
- **Bastion Host**: Terraform execution environment with GCP credentials
- **SSH**: Communication channel between Unify and bastion
- **GCP**: Target infrastructure being managed

## Repository Structure

```
.
├── dns/              # DNS record management
│   ├── main.tf
│   ├── terraform.tfvars.example
│   └── .gitignore
├── compute/          # Compute instances (future)
│   └── README.md
├── networking/       # VPC, subnets, firewalls (future)
│   └── README.md
└── policies/         # Shared OPA policies for all resources
    └── terraform.rego
```

This structure supports multiple resource types while sharing common governance policies.

## DNS Module

The `dns/` directory contains Terraform configuration for managing GCP Cloud DNS records.

### Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `gcp_project` | GCP project ID | Yes | - |
| `gcp_region` | GCP region | No | `us-central1` |
| `dns_zone_name` | Cloud DNS zone name | Yes | - |
| `dns_name` | DNS record name (FQDN with trailing dot) | Yes | - |
| `dns_record_type` | DNS record type (A or CNAME) | No | `A` |
| `dns_records` | List of DNS record values | Yes | - |
| `dns_ttl` | DNS TTL in seconds | No | `300` |

### Outputs

| Output | Description |
|--------|-------------|
| `dns_record_name` | The DNS record name |
| `dns_record_type` | The DNS record type |
| `dns_records` | The DNS record values |

### Usage

1. **On bastion host**, copy the example tfvars:
   ```bash
   cd dns/
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit `terraform.tfvars`** with actual values:
   ```hcl
   gcp_project     = "your-actual-project"
   dns_zone_name   = "your-dns-zone"
   dns_name        = "app.example.com."
   dns_records     = ["34.123.45.67"]
   ```

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Plan changes**:
   ```bash
   terraform plan -out=tfplan
   ```

5. **Apply changes**:
   ```bash
   terraform apply tfplan
   ```

## CloudBees Unify Integration

This Terraform configuration is designed to be orchestrated by CloudBees Unify workflows with comprehensive governance.

**CI/CD Pipeline Flow:**
1. **Git Checkout**: Unify checks out code from this repository
2. **Security Scan**: Checkov analyzes Terraform code for security issues (blocks on CRITICAL/HIGH)
3. **Cost Check**: Infracost estimates monthly costs (blocks if over budget)
4. **Deploy to Bastion**: Code copied to bastion host via SSH
5. **Terraform Plan**: Execute `terraform plan` on bastion (has GCP credentials)
6. **Policy Check**: OPA validates plan against governance policies (DNS rules, naming conventions)
7. **Approval Gate**: Human review of infrastructure changes (optional)
8. **Terraform Apply**: Execute `terraform apply` on bastion
9. **Evidence Publishing**: Full audit trail published to CloudBees

**Governance Controls:**
- ✅ Checkov: Blocks insecure infrastructure configurations
- ✅ OPA: Enforces organizational policies (e.g., DNS TTL >= 300s, FQDN requirements)
- ✅ Infracost: Prevents cost overruns (configurable budget threshold)
- ✅ Evidence: Complete audit trail for compliance

See the `utils` repository for complete Unify workflow definitions.

## Security Model

- **Credentials**: GCP credentials exist only on bastion host
- **Network**: Bastion has private network access to GCP
- **SSH**: Key-based authentication between Unify and bastion
- **State**: Can use local state or GCS backend (configure in main.tf)
- **Audit**: All changes logged through CloudBees Unify audit trail

## Demo Scenarios

### Scenario 1: DNS Change for Deployment
Update DNS A record to point to new load balancer IP before application deployment.

### Scenario 2: Blue/Green Cutover
Change DNS from blue environment to green environment after validation.

### Scenario 3: DR Failover
Update DNS to failover site during disaster recovery scenario.

## Contributing

This repository demonstrates Terraform orchestration patterns. Extend with additional modules as needed:
- Kubernetes resources (via kubernetes provider)
- GCP networking (VPCs, firewall rules)
- Certificate management
- Load balancer configuration

## License

Internal demo repository for CloudBees Squidstack.

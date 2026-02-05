# Squidstack Terraform Infrastructure

Terraform infrastructure management for CloudBees Squidstack demo application using a modular architecture.

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
├── main.tf                  # Root configuration - calls modules
├── variables.tf             # Root input variables
├── outputs.tf               # Root outputs
├── terraform.tfvars         # Configuration values (gitignored)
├── terraform.tfvars.example # Example configuration
├── modules/
│   ├── dns/                 # DNS module - Cloud DNS records
│   │   ├── main.tf
│   │   └── README.md
│   └── compute/             # Compute module - GCP instances
│       ├── main.tf
│       └── README.md
└── policies/                # Shared OPA policies for governance
    └── terraform.rego
```

This modular structure:
- Separates concerns (DNS, compute, networking)
- Enables reusable modules
- Supports independent testing
- Shares governance policies across all infrastructure

## Modules

### DNS Module (`modules/dns/`)

Manages GCP Cloud DNS records.

**Variables:**
- `gcp_project` - GCP project ID
- `dns_zone_name` - Cloud DNS zone name
- `dns_name` - DNS record name (FQDN with trailing dot)
- `dns_record_type` - DNS record type (A or CNAME)
- `dns_records` - List of DNS record values
- `dns_ttl` - DNS TTL in seconds

### Compute Module (`modules/compute/`)

Manages GCP compute instances (optional, for cost demonstration).

**Variables:**
- `gcp_project` - GCP project ID
- `gcp_region` - GCP region
- `create_instance` - Whether to create instance (boolean)
- `instance_name` - Name of the compute instance
- `instance_type` - Machine type (e.g., n1-standard-1)
- `disk_size_gb` - Boot disk size in GB

## Usage

### Local Development

1. **Copy example configuration:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit `terraform.tfvars`** with actual values:
   ```hcl
   gcp_project     = "your-gcp-project"
   dns_zone_name   = "your-dns-zone"
   dns_name        = "app.example.com."
   dns_records     = ["34.123.45.67"]
   ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Plan changes:**
   ```bash
   terraform plan -out=tfplan
   ```

5. **Apply changes:**
   ```bash
   terraform apply tfplan
   ```

### CloudBees Unify Integration

This Terraform configuration is designed to be orchestrated by CloudBees Unify workflows with comprehensive governance.

**CI/CD Pipeline Flow:**
1. **Git Checkout**: Unify checks out code from this repository
2. **Security Scan**: Checkov analyzes Terraform code for security issues (blocks on CRITICAL/HIGH)
3. **Cost Check**: Infracost estimates monthly costs (blocks if over budget)
4. **Deploy to Bastion**: Code copied to bastion host via SSH
5. **Terraform Plan**: Execute `terraform plan` on bastion (has GCP credentials)
6. **Policy Check**: OPA validates plan against governance policies
7. **Approval Gate**: Human review of infrastructure changes (optional)
8. **Terraform Apply**: Execute `terraform apply` on bastion
9. **Evidence Publishing**: Full audit trail published to CloudBees

**Governance Controls:**
- ✅ Checkov: Blocks insecure infrastructure configurations
- ✅ OPA: Enforces organizational policies (e.g., DNS TTL >= 300s, FQDN requirements)
- ✅ Infracost: Prevents cost overruns (configurable budget threshold)
- ✅ Evidence: Complete audit trail for compliance

See the workflow definition in the `utils` repository.

## Security Model

- **Credentials**: GCP credentials exist only on bastion host
- **Network**: Bastion has private network access to GCP
- **SSH**: Key-based authentication between Unify and bastion
- **State**: Can use local state or GCS backend (configure in main.tf)
- **Audit**: All changes logged through CloudBees Unify audit trail

## Demo Scenarios

### Scenario 1: DNS Change for Deployment
Update DNS A record to point to new load balancer IP before application deployment.

### Scenario 2: Cost Governance Demo
Enable compute instance (`create_instance = true`) with large instance type to demonstrate cost blocking when budget is exceeded.

### Scenario 3: Policy Violation Demo
Set `dns_ttl = 60` to demonstrate OPA policy enforcement (requires >= 300).

### Scenario 4: Security Scanning Demo
Add insecure Terraform resource to demonstrate Checkov blocking deployment.

## Contributing

This repository demonstrates Terraform orchestration patterns using a modular architecture. Extend with additional modules as needed:
- Networking (VPCs, subnets, firewall rules)
- Kubernetes resources
- Certificate management
- Load balancer configuration

## License

Internal demo repository for CloudBees Squidstack.

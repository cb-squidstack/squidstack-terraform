# Squidstack Terraform Infrastructure

Terraform infrastructure management for CloudBees Squidstack demo application.

## Purpose

This repository demonstrates CloudBees Unify orchestrating Terraform to manage infrastructure changes (specifically DNS records) without requiring direct infrastructure access. Terraform executes on a bastion host with existing GCP credentials and network connectivity.

## Architecture

- **CloudBees Unify**: Workflow orchestration, approval gates, audit trail
- **Bastion Host**: Terraform execution environment with GCP/DNS access
- **SSH**: Communication channel between Unify and bastion
- **GCP Cloud DNS**: Target infrastructure being managed

## Repository Structure

```
.
└── dns/
    ├── main.tf                    # Terraform configuration for DNS records
    ├── terraform.tfvars.example   # Example variables file
    └── .gitignore                 # Terraform-specific gitignore
```

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

This Terraform configuration is designed to be orchestrated by CloudBees Unify workflows via SSH to a bastion host.

Typical workflow:
1. **Plan Stage**: Unify triggers `terraform plan` on bastion, captures plan output
2. **Approval Gate**: Human review of infrastructure changes
3. **Apply Stage**: Unify triggers `terraform apply` on bastion
4. **Verification**: DNS record verification via `dig`

See the main demo repository for complete Unify workflow definitions.

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

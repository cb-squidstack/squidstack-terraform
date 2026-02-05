# Compute Module

Manages GCP compute instances.

## Usage

```hcl
module "compute" {
  source = "./modules/compute"

  gcp_project     = "my-project"
  gcp_region      = "us-central1"
  create_instance = true
  instance_name   = "my-app"
  instance_type   = "n1-standard-1"
  disk_size_gb    = 20
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| gcp_project | GCP project ID | string | - | yes |
| gcp_region | GCP region | string | "us-central1" | no |
| create_instance | Whether to create instance | bool | false | no |
| instance_name | Name of the compute instance | string | "demo-app" | no |
| instance_type | Machine type | string | "n1-standard-1" | no |
| disk_size_gb | Boot disk size in GB | number | 20 | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_created | Whether instance was created |
| instance_name | The compute instance name (if created) |
| instance_ip | The compute instance external IP (if created) |

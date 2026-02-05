# Terraform State Backend Configuration
# Stores state in Google Cloud Storage with encryption, versioning, and locking
# Prefix is set dynamically via -backend-config during terraform init

terraform {
  backend "gcs" {
    bucket  = "squidstack-terraform-state"
    # prefix is set dynamically:
    #   - dev: terraform/dev
    #   - prod: terraform/prod
    # This ensures separate state files per environment

    # State locking prevents concurrent operations
    # GCS automatically provides locking for Terraform
  }
}

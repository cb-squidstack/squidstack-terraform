# Terraform State Backend Configuration
# Stores state in Google Cloud Storage with encryption, versioning, and locking

terraform {
  backend "gcs" {
    bucket  = "squidstack-terraform-state"
    prefix  = "terraform/state"

    # State locking prevents concurrent operations
    # GCS automatically provides locking for Terraform
  }
}

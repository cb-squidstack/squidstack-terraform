terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # Optional: remote state (can start with local)
  # backend "gcs" {
  #   bucket = "squidstack-terraform-state"
  #   prefix = "infrastructure"
  # }
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

# DNS Module - Manage Cloud DNS records
module "dns" {
  source = "./modules/dns"

  gcp_project     = var.gcp_project
  dns_zone_name   = var.dns_zone_name
  dns_name        = var.dns_name
  dns_record_type = var.dns_record_type
  dns_records     = var.dns_records
  dns_ttl         = var.dns_ttl
}

# Compute Module - Optional compute instances
module "compute" {
  source = "./modules/compute"

  gcp_project     = var.gcp_project
  gcp_region      = var.gcp_region
  create_instance = var.create_instance
  instance_name   = var.instance_name
  instance_type   = var.instance_type
  disk_size_gb    = var.disk_size_gb
}

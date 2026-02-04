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
  #   prefix = "dns/squid-demo"
  # }
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "dns_zone_name" {
  description = "Cloud DNS zone name"
  type        = string
}

variable "dns_name" {
  description = "DNS record name (e.g., squid-demo-3.guru-rep.sa-demo.beescloud.com)"
  type        = string
}

variable "dns_record_type" {
  description = "DNS record type (A or CNAME)"
  type        = string
  default     = "A"
}

variable "dns_records" {
  description = "DNS record values (IPs for A record, hostname for CNAME)"
  type        = list(string)
}

variable "dns_ttl" {
  description = "DNS TTL in seconds"
  type        = number
  default     = 300
}

# Get the DNS zone
data "google_dns_managed_zone" "zone" {
  name = var.dns_zone_name
}

# Create/update DNS record
resource "google_dns_record_set" "app" {
  name         = var.dns_name
  managed_zone = data.google_dns_managed_zone.zone.name
  type         = var.dns_record_type
  ttl          = var.dns_ttl
  rrdatas      = var.dns_records
}

output "dns_record_name" {
  value       = google_dns_record_set.app.name
  description = "The DNS record name"
}

output "dns_record_type" {
  value       = google_dns_record_set.app.type
  description = "The DNS record type"
}

output "dns_records" {
  value       = google_dns_record_set.app.rrdatas
  description = "The DNS record values"
}

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

# Optional compute instance variables (for cost demo)
variable "create_instance" {
  description = "Whether to create a compute instance (for Infracost demo)"
  type        = bool
  default     = false
}

variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
  default     = "dns-demo-app"
}

variable "instance_type" {
  description = "Machine type (e.g., n1-standard-1, n1-standard-4)"
  type        = string
  default     = "n1-standard-1"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
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

# Optional compute instance (for cost demonstration)
resource "google_compute_instance" "demo_app" {
  count        = var.create_instance ? 1 : 0
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = "${var.gcp_region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = var.disk_size_gb
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral external IP
    }
  }

  tags = ["http-server", "https-server"]

  metadata = {
    managed-by = "terraform"
    purpose    = "infracost-demo"
  }
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

output "instance_created" {
  value       = var.create_instance
  description = "Whether a compute instance was created"
}

output "instance_name" {
  value       = var.create_instance ? google_compute_instance.demo_app[0].name : null
  description = "The compute instance name (if created)"
}

output "instance_ip" {
  value       = var.create_instance ? google_compute_instance.demo_app[0].network_interface[0].access_config[0].nat_ip : null
  description = "The compute instance external IP (if created)"
}

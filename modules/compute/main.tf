# Compute Module - Manages GCP compute instances

variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "create_instance" {
  description = "Whether to create a compute instance"
  type        = bool
  default     = false
}

variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
  default     = "demo-app"
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

# Compute instance
resource "google_compute_instance" "app" {
  count        = var.create_instance ? 1 : 0
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = "${var.gcp_region}-a"
  project      = var.gcp_project

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
    purpose    = "demo"
  }
}

output "instance_created" {
  value       = var.create_instance
  description = "Whether a compute instance was created"
}

output "instance_name" {
  value       = var.create_instance ? google_compute_instance.app[0].name : null
  description = "The compute instance name (if created)"
}

output "instance_ip" {
  value       = var.create_instance ? google_compute_instance.app[0].network_interface[0].access_config[0].nat_ip : null
  description = "The compute instance external IP (if created)"
}

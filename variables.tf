# Root Variables - Infrastructure configuration

# GCP Configuration
variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

# DNS Configuration
variable "dns_zone_name" {
  description = "Cloud DNS zone name"
  type        = string
}

variable "dns_name" {
  description = "DNS record name (e.g., app.example.com.)"
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

# Compute Configuration (optional - for cost demo)
variable "create_instance" {
  description = "Whether to create a compute instance (for Infracost demo)"
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

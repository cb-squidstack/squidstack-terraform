# DNS Module - Manages GCP Cloud DNS records

variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

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

# Get the DNS zone
data "google_dns_managed_zone" "zone" {
  name    = var.dns_zone_name
  project = var.gcp_project
}

# Create/update DNS record
resource "google_dns_record_set" "app" {
  name         = var.dns_name
  managed_zone = data.google_dns_managed_zone.zone.name
  type         = var.dns_record_type
  ttl          = var.dns_ttl
  rrdatas      = var.dns_records
  project      = var.gcp_project
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

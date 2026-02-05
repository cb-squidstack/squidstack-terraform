# DNS Module - Manages GCP Cloud DNS records

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

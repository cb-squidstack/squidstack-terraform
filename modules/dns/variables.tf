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

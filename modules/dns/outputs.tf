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

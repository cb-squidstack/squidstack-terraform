# Root Outputs - Infrastructure outputs

# DNS Outputs
output "dns_record_name" {
  value       = module.dns.dns_record_name
  description = "The DNS record name"
}

output "dns_record_type" {
  value       = module.dns.dns_record_type
  description = "The DNS record type"
}

output "dns_records" {
  value       = module.dns.dns_records
  description = "The DNS record values"
}

# Compute Outputs
output "instance_created" {
  value       = module.compute.instance_created
  description = "Whether a compute instance was created"
}

output "instance_name" {
  value       = module.compute.instance_name
  description = "The compute instance name (if created)"
}

output "instance_ip" {
  value       = module.compute.instance_ip
  description = "The compute instance external IP (if created)"
}

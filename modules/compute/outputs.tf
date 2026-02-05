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

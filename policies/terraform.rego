package main

deny[msg] {
  # Check if DNS TTL is less than 300 seconds
  resource := input.resource_changes[_]
  resource.type == "google_dns_record_set"
  resource.change.after.ttl < 300
  msg = sprintf("DNS TTL must be at least 300 seconds, got %d for %s", [resource.change.after.ttl, resource.address])
}

deny[msg] {
  # Check if DNS name ends with a dot (required for GCP)
  resource := input.resource_changes[_]
  resource.type == "google_dns_record_set"
  not endswith(resource.change.after.name, ".")
  msg = sprintf("DNS name must end with a dot, got '%s' for %s", [resource.change.after.name, resource.address])
}

warn[msg] {
  # Warn if TTL is very high (over 1 hour)
  resource := input.resource_changes[_]
  resource.type == "google_dns_record_set"
  resource.change.after.ttl > 3600
  msg = sprintf("DNS TTL is quite high (%d seconds) for %s - consider lowering for faster updates", [resource.change.after.ttl, resource.address])
}

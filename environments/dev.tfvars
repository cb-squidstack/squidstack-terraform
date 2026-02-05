# Development/Demo Environment Configuration

gcp_project     = "se-main-demo"
gcp_region      = "us-central1"
dns_zone_name   = "alt-se-main-demo-sademobeescloudcom"
dns_name        = "squid-demo34.alt-se-main-demo.sa-demo.beescloud.com."
dns_record_type = "A"
dns_records     = ["1.2.3.4"]
dns_ttl         = 300

# Compute instance for cost demo (costs ~$101/month)
# Temporarily disabled to deploy DNS-only infrastructure
create_instance = false
instance_name   = "demo-app"
instance_type   = "n1-standard-4"
disk_size_gb    = 100

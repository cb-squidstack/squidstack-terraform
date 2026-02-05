# Production Environment Configuration

gcp_project     = "se-main-demo"
gcp_region      = "us-central1"
dns_zone_name   = "alt-se-main-demo-sademobeescloudcom"
dns_name        = "squid-prod.alt-se-main-demo.sa-demo.beescloud.com."
dns_record_type = "A"
dns_records     = ["1.2.3.4"]
dns_ttl         = 300

# No compute instance in prod (DNS only, costs ~$0/month)
create_instance = false
instance_name   = "prod-app"
instance_type   = "n1-standard-1"
disk_size_gb    = 20

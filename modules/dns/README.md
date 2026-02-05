# DNS Module

Manages GCP Cloud DNS records.

## Usage

```hcl
module "dns" {
  source = "./modules/dns"

  gcp_project     = "my-project"
  dns_zone_name   = "my-zone"
  dns_name        = "app.example.com."
  dns_record_type = "A"
  dns_records     = ["1.2.3.4"]
  dns_ttl         = 300
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| gcp_project | GCP project ID | string | - | yes |
| dns_zone_name | Cloud DNS zone name | string | - | yes |
| dns_name | DNS record name (FQDN with trailing dot) | string | - | yes |
| dns_record_type | DNS record type (A or CNAME) | string | "A" | no |
| dns_records | List of DNS record values | list(string) | - | yes |
| dns_ttl | DNS TTL in seconds | number | 300 | no |

## Outputs

| Name | Description |
|------|-------------|
| dns_record_name | The DNS record name |
| dns_record_type | The DNS record type |
| dns_records | The DNS record values |

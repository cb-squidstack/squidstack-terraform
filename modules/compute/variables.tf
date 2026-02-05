variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "create_instance" {
  description = "Whether to create a compute instance"
  type        = bool
  default     = false
}

variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
  default     = "demo-app"
}

variable "instance_type" {
  description = "Machine type (e.g., n1-standard-1, n1-standard-4)"
  type        = string
  default     = "n1-standard-1"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

# Compute Module - Manages GCP compute instances

# Compute instance
resource "google_compute_instance" "app" {
  count        = var.create_instance ? 1 : 0
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = "${var.gcp_region}-a"
  project      = var.gcp_project

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = var.disk_size_gb
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral external IP
    }
  }

  tags = ["http-server", "https-server"]

  metadata = {
    managed-by = "terraform"
    purpose    = "demo"
  }
}

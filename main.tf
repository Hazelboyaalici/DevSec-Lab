terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Configure the Google Cloud provider
provider "google" {
  credentials = file("service-account-key.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

# Create a compute instance
resource "google_compute_instance" "vm_instance" {
  name         = "lms-instance"
  machine_type = "e2-medium" # 2 vCPU, 4GB memory

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20 # Size in GB
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  tags = ["http-server", "https-server"]

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Just update package list initially
    apt-get update
  EOF
}

# Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "4000"] # HTTP, HTTPS, backend port
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}
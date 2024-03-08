terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
#it is a plugin that terraform can build infrastructure in that cloud 
provider "google" {
  credentials = "key.json"
  project     = "terraform-build-416616"
  region      = "us-cental1"
  zone        = "us-cental1-a"
}
# creating vm instance
resource "google_compute_network" "vpc_network" {
  name = "network"

}
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

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
resource "google_compute_network" "vpc_network" {
  name = "network"

}

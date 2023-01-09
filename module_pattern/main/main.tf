provider "google" {
  project     = var.project_id
  credentials = file("~path to your gcp json file")
  region      = var.region
  zone        = var.zone

}

module "vpc" {
  source     = "../modules/vpc"
  project_id = var.project_id
}

module "http_traffic" {
  source       = "../modules/vpc/firewall_rules"
  project_id   = var.project_id
  network_name = module.vpc.network_name
}


###Create a VM to use the VPC module
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  metadata_startup_script = file("../startup_script.sh")

  network_interface {
    # A default network is created for all GCP projects
    network = module.vpc.network_name
    access_config {
    }
  }

  tags = ["web", "http-server"]
}
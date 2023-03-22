provider "google" {
  project     = var.project_id
  credentials = file("C:/Users/tumisangm/Documents/Key_Access/chatbot-371908-b2b75222a953.json")
  region      = var.region
  zone        = var.zone

} 


resource "google_compute_instance" "vm_production" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone         = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}

     tags = var.new_tags
  }
}


resource "google_sql_database_instance" "cloud_sql_production" {
  name             = "terraform-mysql"
  database_version = "MYSQL_8_0_26"
  region           = var.region

  settings {
    tier = "db-n1-standard-1"
  }
}



# Create a production instance
resource "google_compute_instance" "production" {
  provider     = google
  name         = "production-flask-vm"
  machine_type = "f1-micro"
  zone         = var.zone_us_west_a
  tags         = ["ssh", "flask-https-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install Apache
  metadata_startup_script = file("./production_startup_script.sh")

  network_interface {
    network = "default"
    access_config {}
  }
}


# Create a development instance
resource "google_compute_instance" "development" {
  provider     = google.development
  name         = "development-apache-vm"
  machine_type = "f1-micro"
  zone         = var.zone_us_west_a
  tags         = ["ssh", "flask-https-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install Apache
  metadata_startup_script = file("./development_startup_script.sh")

  network_interface {
    network = "default"
    access_config {}
  }
}
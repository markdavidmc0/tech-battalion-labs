resource "google_compute_firewall" "http_traffic" {
  project     = var.project_id # Replace this with your project ID in quotes
  name        = "terraform-firewall-rules"
  network     =  var.network_name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web","http-server"]
}
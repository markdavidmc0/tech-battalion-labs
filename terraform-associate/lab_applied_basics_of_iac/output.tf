output "production_instance_ip" {
  value = google_compute_instance.production.network_interface.0.access_config.0.nat_ip
}

output "development_instance_ip" {
  value = google_compute_instance.development.network_interface.0.access_config.0.nat_ip
}
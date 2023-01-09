output "project_id" {
  value       = google_compute_network.vpc_network.project
  description = "Google Cloud project ID"
}

output "network_name" {
  value       = google_compute_network.vpc_network.name
  description = "The name of the VPC being created"
}

output "auto" {
  value       = google_compute_network.vpc_network.auto_create_subnetworks
  description = "The value of the auto mode setting"
}
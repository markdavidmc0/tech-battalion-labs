output "name" {
  value       = google_compute_firewall.http_traffic.name
  description = "The name of the firewall rule being created"
}

output "network_name" {
  value       = google_compute_firewall.http_traffic.network
  description = "The name of the VPC network where the firewall rule will be applied"
}

output "rule_self_link" {
  value       = google_compute_firewall.http_traffic.self_link
  description = "The URI of the firewall rule  being created"
}

output "project_id" {
  value       = google_compute_firewall.http_traffic.project
  description = "Google Cloud project ID"
}
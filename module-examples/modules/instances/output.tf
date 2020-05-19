output "private_ip" {
  value = "${google_compute_instance.instance.network_interface.0.network_ip}"
}
output "public_ip" {
  value = "${google_compute_instance.instance.network_interface.0.access_config.0.nat_ip}"
}

output "instances_self_links" {
  description = "List of self-links for compute instances"
  value       = google_compute_instance.instance.self_link
}
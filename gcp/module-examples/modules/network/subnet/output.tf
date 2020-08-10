output "ip_cidr_range" {
  value = "${google_compute_subnetwork.subnet.ip_cidr_range}"
}
output "self_link" {
  value = "${google_compute_subnetwork.subnet.self_link}"
}
output "subnet_name" {
  value = "${google_compute_subnetwork.subnet.name}"
}
output "subnets" {
  value       = google_compute_subnetwork.subnet
  description = "The created subnet resources"
}
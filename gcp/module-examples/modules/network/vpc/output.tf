output "vpc" {
    value = google_compute_network.vpc
}
output "vpc_name" {
  value = google_compute_network.vpc.name
  sensitive   = false
}
output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}

# output "subnet1_name" {
#   value = "module.subnet1.subnet_name"
# }

# output "subnet2_name" {
#   value = "module.subnet2.subnet_name"
# }

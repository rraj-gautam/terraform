resource "google_compute_network" "vpc" {
    name = var.vpc_name
    auto_create_subnetworks = var.auto_create_subnetworks
    routing_mode = var.routing_mode
    project = var.project_name
}

# resource "google_compute_firewall" "allow-internal" {
#   name    = "${google_compute_network.vpc.name}-allow-internal"
#   network = "${google_compute_network.vpc.name}"
#   #project =  var.project_name
#   //network = "${google_compute_network.default.name}"

#   allow {
#     protocol = "icmp"
#         }

#   allow {
#     protocol = "tcp"
#     ports    = ["0-65535"]
#   }

#   allow {
#     protocol = "udp"
#     ports    = ["0-65535"]
#   }
  
#   source_ranges = [
#         var.subnet1_ip_cidr_range,
#         var.subnet2_ip_cidr_range
#       # "${module.subnet1.ip_cidr_range}",
#       # "${module.subnet2.ip_cidr_range}",
#         # var.subnet["singapore"],
#         # var.subnet["mumbai"],
#         # var.subnet["us"]
#   ]
# }

# resource "google_compute_firewall" "allow-http" {
#   name    = "${google_compute_network.vpc.name}-http"
#   network = "${google_compute_network.vpc.name}"
# allow {
#     protocol = "tcp"
#     ports    = ["80"]
#   }
#   target_tags = ["http"]
#   source_ranges = ["0.0.0.0/0"]
# }

# resource "google_compute_firewall" "allow-https" {
#   name    = "${google_compute_network.vpc.name}-https"
#   network = "${google_compute_network.vpc.name}"
# allow {
#     protocol = "tcp"
#     ports    = ["443"]
#   }
#   target_tags = ["https"]
#   source_ranges = ["0.0.0.0/0"]
# }

# resource "google_compute_firewall" "allow-bastian-ssh" {
#   name    = "${google_compute_network.vpc.name}-bastian-ssh"
#   network = "${google_compute_network.vpc.name}"
# allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }
#   target_tags = ["bastian-ssh"]
#   source_ranges = ["10.10.10.2/32", "35.187.245.16"]
# }
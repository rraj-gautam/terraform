resource "google_compute_firewall" "allow-internal" {
  name    = "${var.vpc_name}-allow-internal"
  network = var.vpc_name
  project =  var.project_name
  //network = "${google_compute_network.default.name}"

  allow {
    protocol = "icmp"
        }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  
  source_ranges = [
         var.subnet1_ip_cidr_range,
         var.subnet2_ip_cidr_range
        # var.subnet["singapore"],
        # var.subnet["mumbai"],
        # var.subnet["us"]
  ]
}

resource "google_compute_firewall" "allow-http" {
  name    = "${var.vpc_name}-http"
  network = var.vpc_name
allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-https" {
  name    = "${var.vpc_name}-https"
  network = var.vpc_name
allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-bastian-ssh" {
  name    = "${var.vpc_name}-bastian-ssh"
  network = var.vpc_name
allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["bastian-ssh"]
  source_ranges = ["10.10.10.2/32"]
}

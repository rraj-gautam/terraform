resource "google_compute_network" "vpc_network"{
  name = "vpc-${var.project-name}" 
  auto_create_subnetworks = "false"
  routing_mode = "GLOBAL"
}

resource "google_compute_firewall" "allow-internal" {
  name    = "vpc-${var.project-name}-allow-internal"
  network = "${google_compute_network.vpc_network.name}"
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
	var.subnet["singapore"],
	var.subnet["mumbai"],
	var.subnet["us"]
  ]
}

resource "google_compute_firewall" "allow-http" {
  name    = "vpc-${var.project-name}-http"
  network = "${google_compute_network.vpc_network.name}"
allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-https" {
  name    = "vpc-${var.project-name}-https"
  network = "${google_compute_network.vpc_network.name}"
allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-bastian-ssh" {
  name    = "vpc-${var.project-name}-bastian-ssh"
  network = "${google_compute_network.vpc_network.name}"
allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["bastian-ssh"]
  source_ranges = ["10.10.10.2/32"]
}


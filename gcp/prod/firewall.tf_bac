resource "google_compute_firewall" "default" {
  name    = "${var.tags}-custom-ports"
  network = "default"
  //network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports    = ["5000", "8080", "5555"]
  }

  target_tags   = [var.tags]
  source_ranges = ["0.0.0.0/0"]
}

//resource "google_compute_network" "default" {
//  name = "default"
//}

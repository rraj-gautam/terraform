provider "google" {
  credentials = file("${var.json-name}")
  project = "${var.project-name}"
  region  = var.region["singapore"]
}


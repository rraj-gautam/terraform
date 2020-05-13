provider "google" {
  credentials = file("${var.json-name}")
  project = "${var.project_name}"
  region  = var.region["singapore"]
}

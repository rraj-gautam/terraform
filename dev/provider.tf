provider "google" {
  credentials = file("${var.json-name}")
  //credentials = "${file("dev-analytics.json")}"
  project = "${var.project-name}"
  region  = "${var.region}"
}


resource "google_compute_subnetwork" "singapore-subnet" {
  name          = "${var.region["singapore"]}-subnet"
  ip_cidr_range = var.subnet["singapore"]
  network       = "${google_compute_network.vpc_network.name}"
  region        = var.region["singapore"]
  private_ip_google_access = "true"

  log_config {
	aggregation_interval = "INTERVAL_10_MIN"
	flow_sampling = 0.5
	metadata = "INCLUDE_ALL_METADATA"
  }
}


resource "google_compute_subnetwork" "us-subnet" {
  name          = "${var.region["us"]}-subnet"
  ip_cidr_range = var.subnet["us"]
  network       = "${google_compute_network.vpc_network.name}"
  region        = var.region["us"]
  private_ip_google_access = "true"

  log_config {
        //flow_logs = "true"
	//subnet_private_access = "true"
	aggregation_interval = "INTERVAL_10_MIN"
	flow_sampling = 0.5
	metadata = "INCLUDE_ALL_METADATA"
  }
}


resource "google_compute_subnetwork" "mumbai-subnet" {
  name          = "${var.region["mumbai"]}-subnet"
  ip_cidr_range = var.subnet["mumbai"]
  network       = "${google_compute_network.vpc_network.name}"
  region        = var.region["mumbai"]
  private_ip_google_access = "true"

  log_config {
        //flow_logs = "true"
	//subnet_private_access = "true"
	aggregation_interval = "INTERVAL_10_MIN"
	flow_sampling = 0.5
	metadata = "INCLUDE_ALL_METADATA"
  }
}

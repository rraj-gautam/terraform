resource "google_compute_subnetwork" "subnet"{
    name = "${var.subnet_name}"
    project = var.project_name
    region = var.region
    network = var.vpc
    ip_cidr_range = var.ip_cidr_range
    private_ip_google_access = "true"
 
    log_config {
        aggregation_interval = "INTERVAL_10_MIN"
        flow_sampling = 0.5
        metadata = "INCLUDE_ALL_METADATA"
    }

}

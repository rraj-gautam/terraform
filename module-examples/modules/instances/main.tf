resource "google_compute_instance" "instance" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.zone

  # metadata {
  #     ssh-keys = "${var.ssh_user}:${file("${var.ssh_key}")}"
  # }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  network_interface {
    network = var.vpc_name
    subnetwork = var.subnet_name
    access_config {
      //this needs to be includes to give vm and ephemeral(dynamic) external IP
    }
  }

  tags = ["http","https","bastian-ssh"]

  #metadata_startup_script = "${file("startup-script.sh")}
}

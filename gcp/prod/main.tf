resource "google_compute_instance" "prod-doc-fe" {
  name         = "prod-doc-fe"
  //machine_type = "${var.vm_type["e2"]}"
  machine_type = var.vm_type["e2-medium"]
  zone         = "${var.region["singapore"]}-b"

  /*provisioner "remote-exec" {
  inline = [
    "sudo yum install unzip wget -y"
  ]
}
*/

  boot_disk {
    initialize_params {
      //image = "${var.os["centos7"]}"
      image = var.os["centos7"]
    }
  }

  network_interface {
    network = "${google_compute_network.vpc_network.name}"
    subnetwork = "${google_compute_subnetwork.singapore-subnet.name}"
    access_config {
      //this needs to be includes to give vm and ephemeral(dynamic) external IP
    }
  }

  tags = ["http","https","bastian-ssh"]

  metadata_startup_script = "${file("startup-script.sh")}"
/*    metadata {
    startup-script = <<EOS
    sudo yum install telnet unzip wget -y
    sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config
    setenforce 0
    yum install https://repo.aerisnetwork.com/stable/centos/7/x86_64/aeris-release-1.0-4.el7.noarch.rpm -y
    yum install nginx-more -y
    systemctl enable --now nginx
    EOS
  }
*/
}

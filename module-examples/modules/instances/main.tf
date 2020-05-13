resource "google_compute_instance" "instance" {
  name         = var.instance_name
  //machine_type = "${var.vm_type["e2"]}"
  machine_type = var.instance_type
  zone         = var.zone

  # metadata {
  #     ssh-keys = "${var.ssh_user}:${file("${var.ssh_key}")}"
  # }
  /*provisioner "remote-exec" {
  inline = [
    "sudo yum install unzip wget -y"
  ]
}
*/

  boot_disk {
    initialize_params {
      //image = "${var.os["centos7"]}"
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

  #metadata_startup_script = "${file("startup-script.sh")}"
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
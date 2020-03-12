resource "google_compute_instance" "default" {
  name         = "analytics-dev"
  //machine_type = "${var.vm_type["e2"]}"
  machine_type = var.vm_type["e2"]
  zone         = "${var.region}-b"

  /*provisioner "remote-exec" {
  inline = [
    "sudo yum install unzip -y"
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
    network = "default"
    access_config {
      //this needs to be includes to give vm and ephemeral(dynamic) external IP
    }
  }

  tags = ["http-server", "https-server", "${var.tags}"]

  metadata_startup_script = "echo terraform test > /ter-test.txt; sudo yum install telnet unzip -y"
  /*  metadata = {
    startup_script = <<EOS
    echo "terraform test" > /ter-test2.txt
    sudo yum install telnet -y
    EOS
  }
*/
}


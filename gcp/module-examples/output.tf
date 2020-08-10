output "instance_public_ip" {
  value = "${module.instance1.public_ip}"
}
output "instance_private_ip" {
  value = "${module.instance1.private_ip}"
}

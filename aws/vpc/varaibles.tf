variable "cidr_vpc"{
    default = "10.10.0.0/16"
}
variable "cidr_subnet_pub"{
    default = "10.10.100.0/24"
}
variable "cidr_subnet_pub-2"{
    default = "10.10.150.0/24"
}
variable "cidr_subnet_priv"{
    default = "10.10.200.0/24"
}
variable "cidr_subnet_priv-2"{
    default = "10.10.50.0/24"
}
variable "pub_availability_zone" {
    default = "us-east-1a"
}
variable "priv_availability_zone" {
    default = "us-east-1b"
}
variable "public_key_path" {
    default = "/home/rishi/Documents/ssh/id_rsa.pub"
}
variable "private_key_path" {
    default = "/home/rishi/Documents/ssh/id_rsa"
}
variable "instance_ami" {
    default = "ami-098f16afa9edf40be"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}
variable "env" {
  description = "Environment tag"
  default = "test"
}

variable "all_cidr"{
    default = "0.0.0.0/0"
}

variable "ssh_user"{
    default = "ec2-user"
}

variable "ssh_port"{
    default = "22"
}

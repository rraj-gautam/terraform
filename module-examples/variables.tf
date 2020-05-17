variable "region" {
  default = {
    "singapore" = "asia-southeast1" // Singapore
    "us" = "us-central1"
    "mumbai" = "asia-south1"
  }
}

variable "project_name" {
  default = "myproject"
}

variable "json-name" {
  default = "key.json"
}

variable "vpc1_name" {
  default = "myvpc"
}

variable "subnet" {
  default = {
        "singapore" = "10.16.101.0/24"
        "mumbai" = "10.16.102.0/24"
        "us" = "10.16.103.0/24"
  }
}

variable "vm_type" {
  default = {
    "f1-micro" = "f1-micro"     // 1-1(core/memory)
    "g1-small" = "g1-small"     // 1-2
    "e2-small" = "e2-small"     // 2-2
    "e2-medium" = "e2-medium"   // 2-4
  }
}

variable "os" {
  default = {
    "centos7"     = "centos-7-v20200309"
    "centos8"     = "centos-8-v20200309"
    "ubuntu-16" = "ubuntu-1604-xenial-v20200223"
    "ubuntu-18" = "ubuntu-1804-bionic-v20200218"
    "ubuntu-19" = "ubuntu-1910-eoan-v20200211"
  }
}


variable "instance_name" {
  default = "myvm"
}

variable "bucket_name" {
  default = "mybucket-1234"
}

variable "backend_bucket_name" {
  default = "tfstate-myapp-bucket"
}

variable "backend_prefix" {
  default = "dev-myapp"
}



variable "ssh_user" {
  default = "rraj"
}

variable "ssh_key" {
  default = "rraj.pub"
}


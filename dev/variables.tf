variable "tags" {
  default = "django"
}

variable "region" {
  default = "asia-southeast1" # Singapore
}

variable "project-name" {
  default = "dev"
}

variable "json-name" {
  default = "dev-analytics.json"
}

variable "vm_type" {
  default = {
    "f1" = "f1-micro"
    "g1" = "g1-small"
    "e2" = "e2-small"
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


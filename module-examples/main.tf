# module "project" {
#   source          = "./modules/project"
#   name            = "hello-${var.env}"
#   region          = "${var.region}"
#   billing_account = "${var.billing_account}"
#   org_id          = "${var.org_id}"
# }


# locals {
#     subnet1_name = "${var.region["us"]}-subnet"
#     subnet1_ip_cidr_range = var.subnet["us"]
#     subnet2_name = "${var.region["singapore"]}-subnet"
#     subnet2_ip_cidr_range = var.subnet["singapore"]
# }

module "vpc1" {
    source = "./modules/network/vpc"
    vpc_name = var.vpc1_name
    project_name = var.project_name
    # subnet1_name = "${var.region["us"]}-subnet"
    # subnet1_ip_cidr_range = var.subnet["us"]
    # subnet1_region = var.region["us"]
    #subnet2_name = "${var.region["singapore"]}-subnet"
    # subnet2_ip_cidr_range = var.subnet["singapore"]
    # subnet2_region = var.region["singapore"]
#     subnets = [
#        {
#             subnet_name           = "${var.region["us"]}-subnet"
#             subnet_ip_cidr_range  = var.subnet["us"]
#             subnet_region         = var.region["us"]
#         },
#        {
#             subnet_name           = "${var.region["singapore"]}-subnet"
#             subnet_ip_cidr_range  = var.subnet["singapore"]
#             subnet_region         = var.region["singapore"]
#         }              
#     ]
}    
module "subnet1" {
  source = "./modules/network/subnet"
  subnet_name = "${var.region["us"]}-subnet"
  project_name = var.project_name
  region = var.region["us"]
  vpc = "${module.vpc1.vpc_self_link}"
  ip_cidr_range = var.subnet["us"]
}
module "subnet2" {
  source = "./modules/network/subnet"
  subnet_name = "${var.region["singapore"]}-subnet"
  project_name = var.project_name
  region = var.region["singapore"]
  vpc = "${module.vpc1.vpc_self_link}"
  ip_cidr_range = var.subnet["singapore"]
}
module vpc1-firewall {
  source = "./modules/network/firewall"
  project_name = var.project_name
  vpc_name = module.vpc1.vpc_name
  subnet1_ip_cidr_range = var.subnet["us"]
  subnet2_ip_cidr_range = var.subnet["singapore"]
}

module "instance1" {
  source = "./modules/instances"
  instance_name = var.instance_name
  instance_type = var.vm_type["f1-micro"]
  zone         = "${var.region["us"]}-b"
  ssh_user     = var.ssh_user
  ssh_key      = var.ssh_key
  image = var.os["centos7"]
  vpc_name = module.vpc1.vpc_name
  subnet_name = module.subnet1.subnet_name
}
**use below block to call this module in your project's main.tf file**
```
module "vpc1-subnet2" {
  source = "github.com/rraj-gautam/terraform/module-examples/modules/network/subnet"
  subnet_name = "${var.region}-subnet"
  project_name = var.project_name
  region = var.region
  vpc = "${module.vpc1.vpc_self_link}"
  ip_cidr_range = var.subnet
}
```

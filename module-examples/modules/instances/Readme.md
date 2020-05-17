**use below block to call this module in your project's main.tf file**
```
module "instance1" {
  source = "github.com/rraj-gautam/terraform/module-examples/modules/instances"
  instance_name = var.instance_name
  instance_type = var.vm_type
  zone         =  var.region
  ssh_user     = var.ssh_user
  ssh_key      = var.ssh_key
  image        = var.os
  vpc_name     = module.vpc1.vpc_name
  subnet_name  = module.subnet1.subnet_name
}
```

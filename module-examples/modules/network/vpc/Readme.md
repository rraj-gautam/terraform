**use below block to call this module in your project's main.tf file**
```
module "vpc1" {
    source = "github.com/rraj-gautam/terraform/module-examples/modules/network/vpc"
    vpc_name = var.vpc1_name
    project_name = var.project_name
}
```

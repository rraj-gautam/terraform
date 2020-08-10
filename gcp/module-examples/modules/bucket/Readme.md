**use below block to call this module in your project's main.tf file**
```
module "bucket1" {
  source = "github.com/rraj-gautam/terraform/module-examples/modules/bucket"
  region = var.region
  bucket_name = var.bucket_name
}
```

# Terraform Modules
* Using backend.tf to save tfstate file in storage bucket in gcp.
```bash
$ terraform init --reconfigure
```
*Note: You need to create the tfstate bucket before using it (either from gsutil or from console UI)*

**To use only targeted resource, use -target argument.**
```bash
$ terraform plan -target=module.bucket1
$ terraform apply -target=module.bucket1
```

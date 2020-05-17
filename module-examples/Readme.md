# Terraform Modules
* Using backend.tf to save tfstate file in storage bucket in gcp.
```bash
$ terraform init --reconfigure
```

**To use only targeted resource, use -target argument.**
```bash
$ terraform plan -target=module.bucket1
$ terraform apply -target=module.bucket1
```

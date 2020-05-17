# Terraform Modules
* Using backend.tf to save tfstate file in storage bucket in gcp.
```bash
$ terraform init --reconfigure
```
*Note: You need to create the tfstate bucket before using it (either from gsutil or from console UI)*

**To use only targeted resource, use *-target* argument.**
```bash
$ terraform plan -target=module.bucket1
$ terraform apply -target=module.bucket1
```
* or use ***-out*** argument to save the plan and apply the plan later.
```bash
$ terraform plan -out=bucket1.plan -target=module.bucket1
$ terraform apply bucket1.plan
```

* To destory the created resource
```bash
$ terraform destroy -target=module.bucket1
```

## Terraform Modules using files *.tfvarfs*
* **variables.tf** = used to define variables (and also declare variable values).
* **variables.tfvarfs** = used to declare varaiable values. It has highest priority. It is also used to seggregate the secrets.
Here, we are using **dev.tfvars** and **prod.tfvars** to seggregate the different environments.

* To create dev environment resources
```bash
$ terraform plan -out=dev-bucket.plan  -target=module.bucket1 -var-file=dev.tfvars
$ terraform apply dev-bucket.plan
```
* To create prod environment resources
```bash
$ terraform plan -out=prod-bucket.plan  -target=module.bucket1 -var-file=prod.tfvars
$ terraform apply prod-bucket.plan
```
* To destory the created resource
```bash
$ terraform destroy -target=module.bucket1 -var-file=prod.tfvars
$ terraform destroy -target=module.bucket1 -var-file=dev.tfvars
```

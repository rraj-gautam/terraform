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

## Terraform Modules using .tfvarfs files
* **variables.tf** = used to define variables (and also declare variable values).
* **variables.tfvarfs** = used to declare varaiable values. It has highest priority. It is also used to seggregate the secrets. By default terraform looks for **terraform.tfvars** file.
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
## Terraform Modules using *workspace*
* **workspace** is used in cases where you can use a same *backend.tf* file for different environments. In general, it seggregates the .tfstate file based on workspace name.  **default** is the default workspace, and **terraform.tfstate** is the default tfstate file. Here we are using **dev** and **prod** workspace for different environment and **dev.tfstate** and **prod.tfstate** are the respective tfstate file maintained by terraform.

* To use the workspace
```bash
$ terraform workspace list // shows all workspaces
$ terraform workspace show // shows current workspace
$ terraform workspace new dev // creates a new workspace named dev
$ terraform workspace new prod // creates a new workspace named prod
$ terraform workspace select dev // selects dev as a current working workspace.
```

## Terraform Modules using *output.tf*
* using ouput.tf to display required output data (and save to a defined variable) from creates resources like Instance IP Address.
* To view all the ouput values of created resource
```bash
$ terraform show
```
This is very useful command. We can use this command to identify how to get output of that value.
* To refresh the changes of ouyput varaibles in config.
```
$ terraform refresh
```
* To list all the output variables
```
$ terraform ouput
```
* To list only required output variables
```
$ terraform ouput instance_public_ip
```

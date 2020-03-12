# Terraform
*Work under **Dev** Folder*

If you want to use backend to store tfstate file in gcloud storage, use the command below, or skip:
```bash
$ gcloud auth application-default login
```
Initialize the configs by below command. This will download all the dependencies and plugins required to run the service.

```bash
$ terraform init 
```
if you get error on syntax due to versions, then do:
```bash
$ terraform -v
$ terraform 0.12upgrade
```
This will modify the syntax accordingly.

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

for more logs: 
```bash
$ TF_LOG=DEBUG terraform apply
```

**NOTE**

If you add network resource, then it will try to create new resource. So, inorder to create a firewall rule on existing network,
define the network name in firewall resource itslef.

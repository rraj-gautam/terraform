#variable "project" {}
 variable "project_name" {}
variable "vpc_name" {}
variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}
variable "auto_create_subnetworks" {
  type        = bool
  default     = false
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."

}
# variable "subnet1_region" {}
# variable "subnet2_region" {}
#  variable "subnet1_ip_cidr_range" {}
#  variable "subnet2_ip_cidr_range" {}
#  variable "subnet1_name" {}
#  variable "subnet2_name" {}
#  variable "project_name" {}

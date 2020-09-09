terraform {
  backend "s3" {
    bucket = "manish-terraform-states"
    key    = "hudson-cluster.tfstate"
    region = "us-east-1"
  }
}

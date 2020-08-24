terraform {
  backend "s3" {
    bucket = "manish-terraform-states"
    key    = "s3.tfstate"
    region = "us-east-1"
  }
}

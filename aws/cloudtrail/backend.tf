terraform {
  backend "s3" {
  bucket = "manish-terraform-states"
  key    = "cloudtrail.tfstate"
  region = "us-east-1"
  }
}

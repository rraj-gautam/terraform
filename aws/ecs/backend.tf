terraform {
  backend "s3" {
  bucket = "manish-terraform-states"
  key    = "clamav.tfstate"
  region = "us-east-1"
  }
}

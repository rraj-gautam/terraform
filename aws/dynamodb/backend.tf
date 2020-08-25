terraform {
  backend "s3" {
    bucket = "manish-terraform-states"
    key    = "dynamodb.tfstate"
    region = "us-east-1"
  }
}

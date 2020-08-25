terraform {
  backend "s3" {
    bucket = "manish-terraform-states"
    key    = "jenkins-cluster.tfstate"
    region = "us-east-1"
  }
}

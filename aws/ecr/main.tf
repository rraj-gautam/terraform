provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


resource aws_ecr_repository "ecr" {
  name                 = "ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    owner = "rishi"
  }
}


resource "null_resource" "docker_build" {
  provisioner "local-exec" {
    command = <<EOF
      docker build ${path.module}/. -t rraj4/clamav:alpine
      docker tag rraj4/clamav:alpine ${aws_ecr_repository.ecr.repository_url}:latest &&
      eval $(aws ecr get-login --no-include-email --region eu-central-1 | sed 's|https://||') &&
      docker push ${aws_ecr_repository.ecr.repository_url} 
    EOF
  }
}

#$(aws ecr get-login --no-include-email --region eu-central-1) &&
#aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.ecr.repository_url} &&




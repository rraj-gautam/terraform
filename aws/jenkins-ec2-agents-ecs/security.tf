resource "aws_security_group" "sg_jenkins" {
  name        = "sg_${var.ecs_cluster_name}"
  description = "Allows all traffic"
  vpc_id      = data.aws_vpc.this.id
  tags = {
    name = "sg_${var.ecs_cluster_name}"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 50000
    to_port   = 50000
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ####################
  # We need this as we'll be adding rules (ingress/egress) to this sg
  ###################
  lifecycle {
    ignore_changes = [
      ingress,
      egress,
    ]
  }   
}

resource "aws_security_group" "sg_jenkins_master" {
  name        = "sg_${var.ecs_cluster_name}-instance"
  description = "Allows all traffic"
  vpc_id      = data.aws_vpc.this.id
  tags = {
    Name = "sg_${var.ecs_cluster_name}"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

    ingress {
    from_port = 50000
    to_port   = 50000
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    security_groups = [aws_security_group.sg_jenkins.id]
  }  

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-efs-jenkins" {
  name = "ingress-efs-jenkins-sg"
  vpc_id      = data.aws_vpc.this.id
  tags = {
    name = "sg_efs_${var.ecs_cluster_name}"
  }


   // NFS
   ingress {
     security_groups = [aws_security_group.sg_jenkins.id]
     from_port = 2049
     to_port = 2049
     protocol = "tcp"
   }

   // Terraform removes the default rule
   egress {
     security_groups = [aws_security_group.sg_jenkins.id]
     from_port = 0
     to_port = 0
     protocol = "-1"
   }
 }
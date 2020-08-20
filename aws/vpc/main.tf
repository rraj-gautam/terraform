provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

### VPC 
resource "aws_vpc" "test-vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    env = var.env
    "Name" = "test-vpc"
  }
}

### public and private subnets 
resource "aws_subnet" "test-subnet-pub" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = var.cidr_subnet_pub
  map_public_ip_on_launch = true
  availability_zone = var.pub_availability_zone
  tags = {
    env = var.env
    "Name" = "test-subnet-pub"
  }
}

resource "aws_subnet" "test-subnet-pub-2" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = var.cidr_subnet_pub-2
  map_public_ip_on_launch = true
  availability_zone = var.priv_availability_zone
  tags = {
    env = var.env
    "Name" = "test-subnet-pub-2"
  }
}


resource aws_subnet "test-subnet-priv" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = var.cidr_subnet_priv
  availability_zone = var.pub_availability_zone
  tags = {
    env = var.env
    "Name" = "test-subnet-priv"
  }

}

resource aws_subnet "test-subnet-priv-2" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = var.cidr_subnet_priv-2
  availability_zone = var.priv_availability_zone
  tags = {
    env = var.env
    "Name" = "test-subnet-priv-2"
  }

}

### for public subnet 
resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id
  tags = {
    env = var.env
    "Name" = "test-igw"
  }
}

resource aws_route_table "test-rtb-pub" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }
  tags = {
    env = var.env
    "Name" = "test-rtb-pub"
  }
}

resource aws_route_table_association "test-rtba-pub" {
  subnet_id      = aws_subnet.test-subnet-pub.id
  route_table_id = aws_route_table.test-rtb-pub.id
}

resource aws_route_table_association "test-rtba-pub-2" {
  subnet_id      = aws_subnet.test-subnet-pub-2.id
  route_table_id = aws_route_table.test-rtb-pub.id
}

### for private subnet
resource aws_eip "test-eip" {
}

resource aws_nat_gateway "test-ngw" {
  allocation_id = aws_eip.test-eip.id
  subnet_id     = aws_subnet.test-subnet-pub.id
  tags = {
      "Name" = "test-ngw"
  }
}

resource aws_route_table "test-rtb-priv" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.test-ngw.id
  }
  tags = {
    env = var.env
    "Name" = "test-trb-priv"
  }
}

resource aws_route_table_association "test-rtba-priv" {
  subnet_id      = aws_subnet.test-subnet-priv.id
  route_table_id = aws_route_table.test-rtb-priv.id
}

### associate existing private route table to new priv-subnet-2
resource aws_route_table_association "test-rtba-priv-2" {
  subnet_id      = aws_subnet.test-subnet-priv-2.id
  route_table_id = aws_route_table.test-rtb-priv.id
}

### security group for public facing instances/subnets
resource aws_security_group "test-sg-web" {
  name   = "test-sg-web"
  vpc_id = aws_vpc.test-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }
  tags = {
    env = var.env
    "Name" = "test-sg-web"
  }
}

### security group for private facing instances/subnets
resource aws_security_group "test-sg-db" {
  name   = "test-sg-db"
  vpc_id = aws_vpc.test-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.test-sg-web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }

  tags = {
    env = var.env
    "Name" = "test-sg-db"
  }

}


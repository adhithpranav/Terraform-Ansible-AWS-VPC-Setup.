provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "kubernetes" {
  cidr_block           = "10.43.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "sub_kubernetes" {
  vpc_id            = aws_vpc.kubernetes.id
  cidr_block        = "10.43.0.0/16"
  availability_zone = "ap-south-1a"
}

resource "aws_internet_gateway" "I_gw" {
  vpc_id = aws_vpc.kubernetes.id
}

resource "aws_route_table" "RT_kubernetes" {
  vpc_id = aws_vpc.kubernetes.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.I_gw.id
  }
}

resource "aws_route_table_association" "RTA_kubernetes" {
  subnet_id      = aws_subnet.sub_kubernetes.id
  route_table_id = aws_route_table.RT_kubernetes.id
}


resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.kubernetes.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "kubernetes_api" {
  vpc_id = aws_vpc.kubernetes.id
  name   = "kubernetes-api"

  # Allow inbound traffic to the port used by Kubernetes API HTTPS
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
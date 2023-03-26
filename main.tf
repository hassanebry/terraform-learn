provider "aws" {
  region     = "eu-west-3"
}

variable "subnet_cidr_block" {
  type        = string
  description = "subnet cidr block"
  default = "10.0.10.0/24"
}

variable "vpc_cidr_block" {
  type        = string
  description = "vpc cidr block"
}

variable "environment" {
  type        = string
  description = "deployment environment"
}


resource "aws_vpc" "dev-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : var.environment,
    vpc_env : "dev"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "eu-west-3a"
  tags = {
    Name : "dev-subnet-1"
  }
}


data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "eu-west-3a"
  tags = {
    Name : "default-subnet-2"
  }
}

output "dev-vpc-id" {
  value       = aws_vpc.dev-vpc.id
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "dev-subnet-1-id" {
  value       = aws_subnet.dev-subnet-1.id
  sensitive   = false
  description = "description"
  depends_on  = []
}
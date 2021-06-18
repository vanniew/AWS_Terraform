terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tf-example"
  cidr = "10.2.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.2.1.0/24"]
  public_subnets  = ["10.2.101.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Owner       = "tf"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "tf-example"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tf-example"
  cidr = "10.2.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.2.1.0/24"]
  public_subnets  = ["10.2.101.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Owner       = "tf"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "tf-example"
  }
}


module "workernodes_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "tf_workernodes"
  description = "Security group to enable open communication between worker nodes"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

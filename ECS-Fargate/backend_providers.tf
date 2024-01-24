terraform {
  backend "s3" {
    bucket  = "ecs-bucket-98"
    region  = "us-east-1"
    key     = "ECS-Fargate/terraform.tfstate"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}
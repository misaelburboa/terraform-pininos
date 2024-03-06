terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.7.4"
}

provider "aws" {
  profile = "misaelburboa"
  region  = "us-east-1"
}

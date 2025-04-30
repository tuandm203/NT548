terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version ="~> 5.11"
      }
    }
    required_version = ">= 1.3.0"
}

provider "aws" {
    region = "ap-southeast-1" # Singapor
}
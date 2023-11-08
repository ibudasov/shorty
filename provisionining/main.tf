terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = "eu-west-1"
  shared_credentials_files = ["/Users/igor/.aws/credentials"]
}

module "security" {
  source = "./modules/00-security"
}

module "database" {
  source = "./modules/01-database"
  depends_on = [ module.security ]
}
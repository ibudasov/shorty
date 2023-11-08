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

module "app" {
  source = "./modules/03-app"
 
  depends_on = [ module.database, module.security ]
 
  bucket_name = module.database.bucket_name
  shorty_lambda_exec_policy_arn = module.security.shorty_lambda_exec_arn
}
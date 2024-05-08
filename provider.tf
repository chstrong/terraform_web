terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 5.46.0"
   }
 }
}

provider "aws" {
  region = "us-east-1"
  shared_config_files      = ["/Users/chstrong/.aws/config"]
  shared_credentials_files = ["/Users/chstrong/.aws/credentials"]
  profile                  = "tailorapp"
}
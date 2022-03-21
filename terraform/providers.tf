## Do not modify this file, this is required for localstack connectivity
terraform {
  required_version = "~> 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.62.0"
    }
  }
}

provider "aws" {
  region                      = "eu-west-1"
  access_key                  = "fake"
  secret_key                  = "fake"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    dynamodb = "http://localhost:4566"
    ## This file will be auto edited when the CI runs it's job
    ## It will modify the above line to http://localstack:4566
  }
}

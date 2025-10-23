terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }

  backend "s3" {
    bucket   = "672642514000-roboshop"
    key = "rabbitmq"
    region = "us-east-1"
    dynamodb_table = "672642514000-roboshop-ddb-lock"
  }
}

provider "aws" {
  # Configuration options
  # you can give access key and secret key here, but security problem
  region = "us-east-1"
}
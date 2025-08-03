terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = ">= 5.91.0"
        }
    }

    backend "s3" {
        bucket = "chaitanya-project-remote-state"
        key = "expense-rds"
        dynamodb_table = "chaitanya-locking"
        region = "us-east-1"
    }
}

provider "aws" {
    region = "us-east-1"
}
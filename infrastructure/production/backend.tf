data "aws_caller_identity" "current" {}

provider "aws" {
  region                  = "us-east-2"
}

/*# Backend must remain commented until the Bucket
 and the DynamoDB table are created.
 After the creation you can uncomment it,
 run "terraform init" and then "terraform apply" */

terraform {
  backend "s3" {
    bucket         = "hill-cc-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "hill-cc-terraform-state"
  }
}

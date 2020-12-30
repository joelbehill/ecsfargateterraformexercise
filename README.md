# README

## Infrastructure

We are using ECS / Fargate and Express (NodeJS).  We are using the AWS Docker Repository to store the image.
## Installation

Use docker and terraform to build the initial image to test and deploy.

### Download Docker

https://www.docker.com/products/docker-desktop

### Download Terraform

```
brew install terraform
```

## Usage

```
terraform plan
terraform apply
```

Once you run the intial ```terraform apply``` you can uncomment out the backend.tf stanza

```
terraform {
  backend "s3" {
    bucket         = "<state-lock>"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "<state-lock>"
  }
}
```

## Notes

On a push to the branch app a new docker container will be created and be uploaded to the ECR repo.

## Discussion

I initially chose to use Ruby on Rails, but after trying out what is the best and quickest way to stand up the infrastructure (Terragrunt, Terraspace, CDK) I didn't have time to think about linking up the backend RDS / migration.  I choose to have a very simple Express app with no database connectivity.

I choose Terraform (raw) because it was easy to install and, if I need to go back to the infrastructure later on it is easier to understand it.  Everyone's needs are different and CDK definitely has some wonderful features, and I am interested in learning it more.

## What's Next

Here are some things that may be necessary going forward

- Script to add a Terraform default user
- Script to disable Endpoints (see https://console.aws.amazon.com/iam/home?region=us-east-2#/account_settings)
- Script to remove entries from all default security groups from all regions except used
- Shore up IAM permissions and users
- AWS Organization?  Maybe?
- Overall calculate long term / per month estimates
- RDS

## Disclaimer

This is not meant for PHI information.  In order to get this ready making sure that there is an SSL endpoint for the task.  Also, make sure that there is an SSL termination on the ALB

## Helpful Tools

https://github.com/johnnyopao/awsp

## License
[MIT](https://choosealicense.com/licenses/mit/)
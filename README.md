# README

## Infrastructure

We are using ECS / Fargate and Express (NodeJS).  We are using the AWS Docker Repository to store the image.
## Installation

Use docker and terraform to build the initial image to test and deploy.  First you need to go into the **infrastructure/backend** folder and run terraform to create resources in dynamodb, s3, and ecr.  This will allow us to create a bucket and dynamo table.  It will also allow us to create an ECR registry.  From there we can upload the image using **app/express/loginBuildPushDocker.sh**.  From there we can go into the folder **infrastructure/production** and run a terraform plan.

### URL

http://main-lb-285429453.us-east-2.elb.amazonaws.com/

### Download Docker

https://www.docker.com/products/docker-desktop

### Download Terraform

```
brew install terraform
```

## Usage

Go into the **infrastructure/backend** folder and run the following

```
terraform init
terraform plan
terraform apply
```

This will create the DynamoDB table, S3 bucket, and ECR Repository.  Please be aware that you must use a unique s3 bucket name and the one listed will not work.

Once you are done go into the **infrastructure/production** folder.  Make sure that the **backend.tf** file has both the bucket and dynamo_table as the one you specified in the files **infrastructure/backend/s3.tf** and **infrastructure/dynamodb.tf**

**backend.tf**
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

Go to **app/express/** and run the following

```
chmod +x loginBuildPushDocker.sh
./loginBuildPushDocker.sh
```

This will prompt you to set your region.  In this repo it is **us-east-2** your generated registry and repository.  This information you can retrieve when you run the backend terraform.

Once that is complete and you receive a success message you can then go into the **infrastructure/production** folder and run the following.

```
terraform plan
terraform apply
```

## Notes

On a push to the branch app a new docker container will be created and be uploaded to the ECR repo.

## Discussion

I initially chose to use Ruby on Rails, but after trying out what is the best and quickest way to stand up the infrastructure (Terragrunt, Terraspace, CDK) I didn't have time to think about linking up the backend RDS / migration.  I choose to have a very simple Express app with no database connectivity.

I choose Terraform (raw) because it was easy to install and, if I need to go back to the infrastructure later on it is easier to understand it.  Everyone's needs are different and CDK definitely has some wonderful features, and I am interested in learning it more.

## Future Ideas

Here are some things that may be useful in the future

- Script to remove entries from all default security groups from all regions except used
- AWS Organization?  Maybe?
- Overall calculate long term / per month estimates
- RDS integration
- CloudFront
- Limit services using Service Policies
- Domain Name purchase via Route 53
- Blue / green deployment instead of changing cluster image
- Separating into modules via git

## Monitoring Traffic

There are a few ways to monitor traffic.  VPC Flow Logs are an option but there is also the virtual traffic mirroring to see the actual data and attach an IDS to it.  They are not created in this repository, for monetary reasons, but remanents exist.  There is of course CloudWatch logs as well.

However, I would really just like an external ping / web test using a monitor like New Relic or something like that where I can be sured that my users can see this page.  I think in this demo it is too much because it is not meant to be production but it would give me peace of mind.
## Disclaimer

This is not meant for PHI information.  In order to get this ready making sure that there is an SSL endpoint for the task.  Also, make sure that there is an SSL termination on the ALB

## Helpful Tools

https://github.com/johnnyopao/awsp

## License
[MIT](https://choosealicense.com/licenses/mit/)
# README

## Infrastructure

We are using ECS / Fargate and Express (NodeJS).  We are using the AWS Docker Repository to store the image.
## Installation

Use docker and terraform to build the initial image to test and deploy.  First you need to go into the **infrastructure/backend** folder and run terraform to create resources in dynamodb, s3, and ecr.  This will allow us to create a bucket and dynamo table.  It will also allow us to create an ECR registry.  From there we can upload the image using **app/express/loginBuildPushDocker.sh**.  From there we can go into the folder **infrastructure/production** and run a terraform plan.

## URL

http://main-lb-285429453.us-east-2.elb.amazonaws.com/

### Download Docker

https://www.docker.com/products/docker-desktop

### Download Terraform

```
brew install terraform
```

Load your AWS profile and run the following command to create an ECR repository

```
aws ecr create-repository --repository-name test
```

You will get an output like the one below.

```
{
    "repository": {
        "repositoryArn": "arn:aws:ecr:us-east-2:aaaaaaaaaaaa:repository/test",
        "registryId": "aaaaaaaaaaaa",
        "repositoryName": "test",
        "repositoryUri": "aaaaaaaaaaaa.dkr.ecr.us-east-2.amazonaws.com/test",
        "createdAt": "2020-12-29T19:57:12-06:00",
        "imageTagMutability": "MUTABLE",
        "imageScanningConfiguration": {
            "scanOnPush": false
        },
        "encryptionConfiguration": {
            "encryptionType": "AES256"
        }
    }
}
```

Take this part of the URL and add it to the file **loginBuildPushDocker.sh**


ECR

```
aaaaaaaaaaaa.dkr.ecr.us-east-2.amazonaws.com
```

URI
```
aaaaaaaaaaaa.dkr.ecr.us-east-2.amazonaws.com/test
```

Repository Name

```
test
```

After you install docker go to ```app/express```.  When you run the script it will ask you for the above information.

```
chmod +x loginBuildPushDocker.sh
./loginBuildPushDocker.sh
```

## Usage

Go into the **infrastructure/backend** folder and run the following

```
terraform init
terraform plan
terraform apply
```

This will create the DynamoDB table and s3 bucket.  Please be aware that you must use a unique s3 bucket name and the one listed will not work.

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

```
terraform plan
terraform apply
```

Once you run the intial ```terraform apply``` you can uncomment out the backend.tf stanza

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
## Disclaimer

This is not meant for PHI information.  In order to get this ready making sure that there is an SSL endpoint for the task.  Also, make sure that there is an SSL termination on the ALB

## Helpful Tools

https://github.com/johnnyopao/awsp

## License
[MIT](https://choosealicense.com/licenses/mit/)
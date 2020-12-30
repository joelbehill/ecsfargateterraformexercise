# README

## Infrastructure

We are using ECS / Fargate and Express.  We are using the AWS Docker Repository.
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

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Disclaimer

This is not meant for PHI information.
## License
[MIT](https://choosealicense.com/licenses/mit/)
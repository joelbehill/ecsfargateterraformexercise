variable "ecr" {
  default = "730061254062.dkr.ecr.us-east-2.amazonaws.com/express:latest"
  type    = string
}

variable "default_tags" {
  type = map(string)
  default = {
    Team: "The Awesome IT Team"
    Environment: "Production"
    ManagedBy: "Terraform"
  }
}

variable "allowed_ips" {
  default = ["0.0.0.0/0"]
  type = list
}
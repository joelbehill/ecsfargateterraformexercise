variable "ecr" {
  default = "730061254062.dkr.ecr.us-east-2.amazonaws.com/express:latest"
  type    = string
}

variable "default_tags" {
  type = map(string)
  default = {
    team: "The Awesome IT Team"
    env: "production"
  }
}

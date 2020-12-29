module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "production"
  cidr = "172.16.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  public_subnets  = ["172.16.101.0/24", "172.16.102.0/24", "172.16.103.0/24"]

  enable_nat_gateway  = true
  single_nat_gateway  = false
  reuse_nat_ips       = true                    # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = aws_eip.nat.*.id   # <= IPs specified here as input to the module

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_eip" "nat" {
  count = 3

  vpc = true
}


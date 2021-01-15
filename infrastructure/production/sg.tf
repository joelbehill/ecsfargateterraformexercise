# Creating a security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group" {
  name = "load_balancer_security_group"

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80 # Allowing traffic in from port 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }

  tags = merge(
    var.default_tags,
    {
      Name = "alb-external"
    },
  )

  depends_on = [
    module.vpc
  ]
}

resource "aws_security_group" "service_security_group" {
  name = "service_security_group"

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }

  depends_on = [
    aws_security_group.load_balancer_security_group, module.vpc.id
  ]

  tags = merge(
    var.default_tags,
    {
      Name = "service-security-group"
    },
  )
}
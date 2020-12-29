resource "aws_alb" "application_load_balancer" {
  name               = "main-lb" # Naming our load balancer
  load_balancer_type = "application"
  subnets = module.vpc.public_subnets
  # Referencing the security group
  security_groups = [aws_security_group.load_balancer_security_group.id]

  tags = var.default_tags
}

resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
  health_check {
    matcher = "200,301,302"
    path = "/"
  }

  tags = var.default_tags
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn # Referencing our tagrte group
  }

  depends_on = [
    aws_lb_target_group.target_group, aws_alb.application_load_balancer
  ]
}
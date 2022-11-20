resource "aws_ecs_cluster" "example_cluster" {
  name = "example" # Naming the cluster

  tags = merge(
    var.default_tags,
    {
      Name = "example-cluster"
    },
  )
}

resource "aws_ecs_task_definition" "main_task" {
  family                   = "main-task" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "main-task",
      "image": "${var.ecr}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  tags = merge(
    var.default_tags,
    {
      Name = "main-task"
    },
  )

  depends_on = [
    aws_iam_role.ecsTaskExecutionRole
  ]
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "main_service" {
  name            = "main-service"                             # Naming our first service
  cluster         = aws_ecs_cluster.example_cluster.id             # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.main_task.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.main_task.family
    container_port   = 8080 # Specifying the container port
  }

  network_configuration {
    subnets          = module.vpc.private_subnets
    assign_public_ip = true                                                # Providing our containers with public IPs
    security_groups  = [aws_security_group.service_security_group.id] # Setting the security group
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = merge(
    var.default_tags,
    {
      Name = "main-service"
    },
  )

  depends_on = [
    module.vpc.private_subnets, aws_lb_target_group.target_group, aws_ecs_task_definition.main_task, aws_security_group.service_security_group, aws_ecs_cluster.example_cluster
  ]
}
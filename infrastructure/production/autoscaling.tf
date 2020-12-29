resource "aws_appautoscaling_target" "main_target" {
  max_capacity = 5
  min_capacity = 1
  resource_id = "service/${aws_ecs_cluster.casechek_cluster.name}/${aws_ecs_service.main_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

/*
resource "aws_appautoscaling_policy" "main_memory_policy" {
  name               = "main-memory-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.main_target.resource_id
  scalable_dimension = aws_appautoscaling_target.main_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.main_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
  }
}
*/

resource "aws_appautoscaling_policy" "main_cpu_policy" {
  name = "main-cpu-policy"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.main_target.resource_id
  scalable_dimension = aws_appautoscaling_target.main_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.main_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}
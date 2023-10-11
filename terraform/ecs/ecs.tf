
# ECS cluster
resource "aws_ecs_cluster" "application" {
  name = "${var.environment}-${var.application_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    "environment" = "${var.environment}"
  }
}


resource "aws_ecs_service" "service" {

  for_each                           = var.services
  name                               = each.value.application_name #must be the same as container name in task definition
  cluster                            = aws_ecs_cluster.application.id
  task_definition                    = aws_ecs_task_definition.service[each.key].arn
  desired_count                      = each.value.desired_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.service[each.key].id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.service[each.key].arn
    container_name = each.value.application_name
  }

  dynamic "load_balancer" {
    for_each = each.value.enable_alb == true ? [1] : []
    content {

      target_group_arn = aws_alb_target_group.service[each.key].arn
      container_name   = each.value.application_name
      container_port   = each.value.container_port
    }
  }

  #  lifecycle {
  #    ignore_changes = [task_definition, desired_count]
  #  }
}



#log group for container logs
resource "aws_cloudwatch_log_group" "service" {
  for_each = var.services
  name     = "/ecs/${each.value.application_name}-task-${var.environment}"

  tags = {
    Name        = "${each.value.application_name}-task-${var.environment}"
    Environment = var.environment
  }
}


data "template_file" "service" {
  for_each = var.services
  template = file("${each.value.template_file}")

  vars = {
    name                    = each.value.application_name
    container_image         = each.value.container_image
    container_image_version = each.value.container_image_version
    cpu                     = each.value.cpu
    memory                  = each.value.memory
    container_port          = each.value.container_port
    host_port               = each.value.host_port
    log_group               = aws_cloudwatch_log_group.service[each.key].name #work on resource
    region                  = var.region
  }
}

resource "aws_ecs_task_definition" "service" {
  for_each                 = var.services
  family                   = each.value.application_name
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  network_mode             = "awsvpc"
  container_definitions    = data.template_file.service[each.key].rendered
}



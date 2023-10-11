resource "aws_lb" "service" {
  for_each = {
    for k, v in var.services : k => v if v.enable_alb
  }
  name               = "main-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.service_alb[each.key].id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false
}

resource "aws_alb_target_group" "service" {
  for_each = {
    for k, v in var.services : k => v if v.enable_alb
  }
  name        = "${each.value.application_name}-tg-${var.environment}"
  port        = each.value.target_group_port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200,302"
    timeout             = "3"
    path                = each.value.health_check_path
    unhealthy_threshold = "2"
  }
}

locals {

}

resource "aws_alb_listener" "service_http" {
  for_each = {
    for k, v in var.services : k => v if v.enable_alb
  }
  load_balancer_arn = aws_lb.service[each.key].id
  port              = each.value.http_ingress_port
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = each.value.enable_dns == true ? [] : [1]

    content {
      type             = "forward"
      target_group_arn = aws_alb_target_group.service[each.key].arn
    }
  }

  dynamic "default_action" {
    for_each = {
      for k, v in var.services : k => v if v.enable_dns
    }
    iterator = item
    content {
      type = "redirect"

      redirect {
        port        = item.value.https_ingress_port
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }
}

resource "aws_alb_listener" "service_https" {
  for_each = {
    for k, v in var.services : k => v if v.enable_dns
  }
  load_balancer_arn = aws_lb.service[each.key].id
  port              = each.value.https_ingress_port
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.alb_tls_cert_arn

  default_action {
    target_group_arn = aws_alb_target_group.service[each.key].id
    type             = "forward"
  }
}
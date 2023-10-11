
#load balancer security group
resource "aws_security_group" "service_alb" {
  for_each = {
    for k, v in var.services : k => v if v.enable_alb
  }
  name   = "${each.key}-sg-alb-${var.environment}"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = each.value.http_ingress_port
    to_port          = each.value.http_ingress_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = each.value.https_ingress_port
    to_port          = each.value.https_ingress_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  revoke_rules_on_delete = true

  tags = {
    "Name"        = "${each.value.application_name} load balancer security group"
    "Environment" = var.environment
  }

}


resource "aws_security_group" "service" {
  for_each = var.services
  name     = "${each.value.application_name}-sg-task-${var.environment}"
  vpc_id   = module.vpc.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = each.value.container_port
    to_port   = each.value.container_port

    #restricting ingress traffic from alb
    #  security_groups  = [aws_security_group.service_alb[each.key].id] #fix this to allow traffic from alb or service
    #security_groups  = [for service in each.value.sg_whitelist : aws_security_group.service_alb[each.key].id] #fix this to allow traffic from alb or service

    cidr_blocks = ["0.0.0.0/0"]
    #  ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  revoke_rules_on_delete = true

  tags = {
    "Name"        = "${each.value.application_name} security group"
    "Environment" = var.environment
  }

}

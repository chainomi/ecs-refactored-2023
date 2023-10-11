resource "aws_ecr_repository" "ecr" {
  for_each = {
    for k, v in var.services : k => v if v.enable_ecr
  }
  name                 = each.value.application_name
  image_tag_mutability = each.value.image_mutability

  tags = {
    "environment" = "${var.environment}"
  }
}


# Retrieving AWS account ID for ECR push command
data "aws_caller_identity" "current" {}
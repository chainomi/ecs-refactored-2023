output "region" {
  description = "AWS region"
  value       = var.region
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.id
}

output "ecr_repo_url_map" {
  value = { for k, v in aws_ecr_repository.ecr : k => v.repository_url }
}


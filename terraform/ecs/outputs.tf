output "region" {
  description = "AWS region"
  value       = var.region
}

output "load_balancer_dns" {
  value = { for k, v in aws_lb.service : k => v.dns_name }
}



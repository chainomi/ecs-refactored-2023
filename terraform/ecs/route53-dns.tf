data "aws_route53_zone" "service" {
    for_each = {
    for k, v in var.services : k => v if v.enable_alb && v.enable_dns
  }
  name         = var.route_53_hosted_zone_domain_name
  private_zone = false
}

resource "aws_route53_record" "www" {
  for_each = {
    for k, v in var.services : k => v if v.enable_alb && v.enable_dns
  }
  zone_id = data.aws_route53_zone.service[each.key].zone_id
  name    = each.value.service_domain
  type    = "A"

  alias {
    name                   = aws_lb.service[each.key].dns_name
    zone_id                = aws_lb.service[each.key].zone_id
    evaluate_target_health = true
  }
}
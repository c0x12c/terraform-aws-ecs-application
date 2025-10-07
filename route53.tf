/*
aws_route53_record provides a Route53 record resource for ALB of the ECS service.
*/
resource "aws_route53_record" "this" {
  count = var.use_alb && length(var.load_balancer_configurations) == 0 ? 1 : 0

  name    = var.dns_name
  zone_id = var.route53_zone_id
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# Route53 records for each load balancer configuration with a custom host value
resource "aws_route53_record" "load_balancer" {
  for_each = {
    for index, config in local.load_balancer_configs_map : index => config
    if config.listener_rule_host_value != null
  }

  name    = each.value.listener_rule_host_value
  zone_id = var.route53_zone_id
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

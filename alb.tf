resource "aws_lb_target_group" "this" {
  for_each = {
    for index, config in local.load_balancer_configs_map : index => config
    if config.target_group_arn == null
  }

  name        = each.value.target_group_name != null ? each.value.target_group_name : "${var.name}-tg-${each.key}"
  port        = each.value.target_group_port != null ? each.value.target_group_port : each.value.container_port
  protocol    = each.value.target_group_protocol
  target_type = "ip"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    enabled             = each.value.health_check_enabled
    healthy_threshold   = each.value.health_check_healthy_threshold
    interval            = each.value.health_check_interval
    protocol            = each.value.target_group_protocol
    port                = each.value.target_group_port != null ? each.value.target_group_port : each.value.container_port
    matcher             = each.value.health_check_matcher
    timeout             = each.value.health_check_timeout
    path                = each.value.health_check_path
    unhealthy_threshold = each.value.health_check_unhealthy_threshold
  }

  tags = {
    Name        = each.value.target_group_name != null ? each.value.target_group_name : "${var.name}-tg-${each.key}"
    Environment = var.environment
  }
}

resource "aws_lb_listener_rule" "this" {
  for_each = {
    for index, config in local.load_balancer_configs_map : index => config
    if config.create_listener_rule == true
  }

  listener_arn = each.value.listener_arn != null ? each.value.listener_arn : var.aws_lb_listener_arn
  priority     = each.value.listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = each.value.target_group_arn != null ? each.value.target_group_arn : aws_lb_target_group.this[each.key].arn
  }

  condition {
    host_header {
      values = [each.value.listener_rule_host_value != null ? each.value.listener_rule_host_value : try(aws_route53_record.this[0].fqdn, "")]
    }
  }

  tags = {
    Name        = "${var.name}-listener-rule-${each.key}"
    Environment = var.environment
  }
}

module "this_task" {
  source = "github.com/ramonesc3po/terraform-aws-ecs-tasks.git?ref=develop"

  tier                      = var.tier
  organization              = var.organization
  cluster_id                = var.cluster_id
  name_ecs_task             = var.name_service
  ecs_container_definitions = var.container_definition
  desired_count             = var.desired_count
  lb_target_group_name      = module.this_ingress.target_group_name

  tags = var.tags
}

locals {
  rule_condition_host_header = {
    field  = var.rule_condition_host_header != [] ? "host-header" : null
    values = var.rule_condition_host_header != [] ? var.rule_condition_host_header : null
  }
  rule_condition_path = {
    field  = "path-pattern"
    values = var.rule_condition_path
  }
}

module "this_ingress" {
  source = "github.com/ramonesc3po/terraform-aws-elb-ingress.git?ref=develop"

  tier         = var.tier
  ingress_name = var.name_service
  ingress_port = var.loadbalancer.port
  lb_name      = var.loadbalancer.name

  rule_condition = [
    local.rule_condition_path,
    local.rule_condition_host_header
  ]

  target_group = {
    port                 = 80
    protocol             = "HTTP"
    deregistration_delay = var.deregistration_delay
    target_type          = "ip"
    health_check = {
      enabled             = lookup(var.health_check, "enabled", true)
      path                = lookup(var.health_check, "path", "/")
      protocol            = lookup(var.health_check, "protocol", "HTTP")
      matcher             = lookup(var.health_check, "matcher", 200)
      interval            = lookup(var.health_check, "interval", 100)
      timeout             = lookup(var.health_check, "timeout", 60)
      health_threshold    = lookup(var.health_check, "health_threshold", 2)
      unhealthy_threshold = lookup(var.health_check, "unhealthy_threshold", 2)
    }
  }

  tags = var.tags
}
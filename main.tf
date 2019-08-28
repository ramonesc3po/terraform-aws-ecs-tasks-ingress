module "this_task" {
  source = "github.com/ramonesc3po/terraform-aws-ecs-tasks.git?ref=develop"

  tier                      = var.tier
  organization              = var.organization
  cluster_id                = var.cluster_id
  name_ecs_task             = var.name_service
  ecs_container_definitions = var.container_definition

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
    local.rule_condition_path
  ]

  tags = var.tags
}
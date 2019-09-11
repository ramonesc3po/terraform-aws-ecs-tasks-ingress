variable "tier" {}

variable "organization" {}

variable "cluster_id" {}

variable "loadbalancer" {
  type = object({
    name = string
    port = number
  })
}

variable "name_service" {}

variable "tags" {
  default = {}
}

variable "rule_condition_path" {
  description = "Rule condition in https://www.terraform.io/docs/providers/aws/r/lb_listener_rule.html"
}

variable "rule_condition_host_header" {
  type        = "list"
  description = "Rule condition in https://www.terraform.io/docs/providers/aws/r/lb_listener_rule.html"
  default     = []
}

variable "container_definition" {
  description = "Container definition JSON"
}

variable "deregistration_delay" {
  default = 60
}

variable "health_check" {
  type    = "map"
  default = {}
}
provider "aws" {
  region = "us-east-1"
}

module "simple-task-ingress" {
  source = "../"

  tier                 = "staging"
  organization         = "simple-org"
  name_service         = "simple-service"
  cluster_id           = "cluster-id"
  container_definition = local.container_nginx

  loadbalancer = {
    name = "existing-loadbalancer-name"
    port = 443
  }
  rule_condition_path = ["/api"]
}

locals {
  container_nginx = <<EOF
  [
  {
    "name": "simple-service-staging",
    "image": "nginx",
    "cpu": 1,
    "memory": 64,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ],
    "Environment" : [
      {
        "Name": "SERVER_NAME",
        "Value": "localhost"
      }
    ]
  }
  ]
  EOF
}
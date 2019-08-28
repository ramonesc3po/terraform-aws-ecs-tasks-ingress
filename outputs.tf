output "task_family_name" {
  value = element(concat(module.this_task.*.ecs_task_family_name, list("")), 0)
}

output "service_name" {
  value = element(concat(module.this_task.*.ecs_service_name, list("")), 0)
}
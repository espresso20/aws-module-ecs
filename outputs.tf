output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.main.arn
  description = "AWS ARN for the ECS Cluster"
}

output "ecs_task_defintion_arn" {
  # Don't love this but you can't do a for_each for an output
  value = tomap({
    for key, value in aws_ecs_task_definition.main : key => value.arn
  })
  description = "Map of ARNs for task definitions. Map Keys match the input of the `ecs_task_definitions` variable"
}

output "load_balancer_zone_id" {
  value       = var.enable_load_balancer ? aws_lb.main[0].zone_id : null
  description = "If Load Balancer is enabled, this will be the Zone ID of the LB"
}

output "load_balancer_dns_name" {
  value       = var.enable_load_balancer ? aws_lb.main[0].dns_name : null
  description = "If Load Balancer is enabled, this will be the DNS Name of the LB"
}
data "aws_ecs_task_definition" "main" {
  for_each = var.ecs_task_definitions

  task_definition = each.value.family
  depends_on      = [aws_ecs_task_definition.main]
}

data "aws_security_groups" "main" {
  for_each = var.ecs_service_definitions

  filter {
    name   = "group-name"
    values = each.value.security_groups
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
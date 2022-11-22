locals {
  combined_subnets = distinct(
    flatten(
      [for key, value in var.ecs_service_definitions : value.subnets]
    )
  )

  combined_security_groups = distinct(
    flatten(
      [for key, value in data.aws_security_groups.main : value.ids]
    )
  )
}
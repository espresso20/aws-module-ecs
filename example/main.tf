module "ecs" {
  source = "./"

  cluster_name            = local.cluster_name
  ecs_service_definitions = local.ecs_service_definitions
  ecs_task_definitions    = local.ecs_task_definitions
  shared_tags             = local.shared_tags
  vpc_id                  = local.vpc_id

  # Load Balancer
  enable_load_balancer              = local.enable_load_balancer
  load_balancer_type                = local.load_balancer_type
  load_balancer_listener_container  = local.load_balancer_listener_container
  load_balancer_listener_port       = local.load_balancer_listener_port
  load_balancer_listener_protocol   = local.load_balancer_listener_protocol
  load_balancer_target_port         = local.load_balancer_target_port
  load_balancer_target_protocol     = local.load_balancer_target_protocol
  load_balancer_listener_ssl_cert   = data.aws_acm_certificate.main.arn
  load_balancer_listener_ssl_policy = local.load_balancer_listener_ssl_policy
  load_balancer_http_redirect       = local.load_balancer_http_redirect

  target_group_health_check_enabled             = local.target_group_health_check_enabled
  target_group_health_check_response_codes      = "200-299,300-302"
  target_group_health_check_healthy_threshold   = 2
  target_group_health_check_interval            = 65
  target_group_health_check_timeout             = 60
  target_group_health_check_unhealthy_threshold = 4
}

# module "redis" {
#   source = "./modules/elasticache-redis"

#   cluster_name         = local.cluster_name
#   auth_token           = random_id.redis_auth.hex
#   engine_version       = local.engine_version
#   node_type            = local.redis_node_type
#   port                 = local.redis_port
#   parameter_group_name = local.parameter_group
#   kms_key_id           = data.aws_kms_key.main.arn
#   security_group_names = local.security_group_names
#   subnet_ids           = local.redis_subnets
#   vpc_id               = local.vpc_id

#   shared_tags = local.shared_tags
# }

# module "postgres" {
#   source = "./modules/rds"
#   count  = local.db_enabled ? 1 : 0

#   allocated_storage      = local.db_storage
#   db_admin_secret        = local.db_admin_secret
#   engine_version         = local.db_engine_version
#   major_engine_version = local.db_major_engine_version
#   instance_class         = local.db_instance_class
#   instance_name          = local.db_instance_name
#   db_name                = local.db_database_name
#   option_group_name      = local.db_option_group_name
#   parameter_group_name   = local.db_parameter_group_name
#   subnet_ids             = local.redis_subnets
#   tags                   = local.shared_tags
#   username               = local.db_username
#   vpc_security_group_ids = local.db_security_group_ids
#   multi_az               = local.db_multi_az
#   apply_immediately      = local.db_apply_immediately
#   backup_retention_period = local.db_backup_retention_period
#   preferred_backup_window = local.db_preferred_backup_window
#   deletion_protection     = local.db_deletion_protection
#   storage_encrypted       = local.db_storage_encrypted
#   kms_key_id              = data.aws_kms_key.main.arn

#   shared_tags = local.shared_tags
# }

resource "random_id" "redis_auth" {
  byte_length = 16
}

resource "aws_secretsmanager_secret_version" "redis_auth" {
  secret_id     = data.aws_secretsmanager_secret.redis_auth.id
  secret_string = random_id.redis_auth.hex
}

resource "aws_route53_record" "main" {
  zone_id = local.route_53_zone_id
  name    = local.dns_name
  type    = "A"

  alias {
    name                   = module.ecs.load_balancer_dns_name
    zone_id                = module.ecs.load_balancer_zone_id
    evaluate_target_health = false
  }
}
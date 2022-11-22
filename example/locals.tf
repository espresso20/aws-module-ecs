locals {
  env = terraform.workspace

  # ECS Cluster and Redis Cluster name
  # This is dictated by our team
  cluster_name = "demo-${local.env}"

  # ECS Worker Name
  demo_worker_name = "${local.cluster_name}-worker"

  # The ECS Service definiton.
  # This is fed by other environment specific values so this can be used for across all envs
  ecs_service_definitions = {
    demo-worker = {
      name                  = "demo-worker"
      task                  = "demo"
      desired_count         = local.service_desired_count
      launch_type           = "FARGATE"
      wait_for_steady_state = true
      security_groups       = local.security_group_names
      subnets               = local.subnet_ids
      assign_public_ip      = false
    }
  }

  # The ECS Task definition
  # This is fed by other environment specific values so this can be used for across all envs
  ecs_task_definitions = {
    demo = {
      family                   = local.demo_worker_name
      container_definitions    = local.container_definitions
      requires_compatibilities = ["FARGATE"]
      cpu                      = 256
      memory                   = 2048
      network_mode             = "awsvpc"
      execution_role_arn       = aws_iam_role.demo_execution_role.arn
      task_role_arn            = aws_iam_role.demo_execution_role.arn
    }
  }

  # The desired number of workers for this service.
  # May need to be adjusted by environment
  service_desired_count_list = {
    dev  = 2
    prod = 2
  }

  # Security Group names to apply to ECS Cluster and Redis Cluster
  # These are standard SGs set up for the entire Spoke.
  # Names may change slightly by environment. These can be found within your AWS Spoke
  security_group_names_list = {
    dev  = ["DEMO-GROUP"]
    prod = ["DEMO-GROUP"]
  }

  # Tags to be applied to all services created by this IAC Stack
  # These should correspond to the demo issued App IDs
  shared_tags_list = {
    dev = {
      Lifecycle = "Develop"
    }
    prod = {
      Lifecycle = "Production"
    }
  }

  # KMS key to be used for Secrets and the Redis Cluster
  # This is already provisioned within the spoke
  # Names may vary slightly per spoke and environment
  kms_data_alias_list = {
    dev  = "DEMO_DEV_KEY"
    prod = "DEMO_PROD_KEY"
  }

  # Additional task roles to add to the ECS Service
  # Not currently needed thus far
  app_task_role_policies_list = {
    dev  = []
    prod = []
  }

  # Name of the AWS Secret Manager Secret that will be accessed by ECS to get the demo Password
  # This is created manually by hand before the infra is spun up
  demo_secret_name_list = {
    dev  = "dev/demo/demo-password"
    prod = "prod/demo/pdemo-password"
  }

  demo2_secret_name_list = {
    dev  = "dev/demo/demo2-password"
    prod = "prod/demo/pdemo2-password"
  }

example_secret_name_list = {
    dev  = "dev/demo/example-password"
    prod = "prod/demo/example-password"
  }

  # Name of the AWS Secret Manager Secret that will be access by ECS to get the Django Secret Key
  # This is created manually by hand before the infra is spun up
  secret_key_secret_name_list = {
    dev  = "dev/demo/secret-key"
    prod = "prod/demo/secret-key"
  }

  # The Subnet IDs where the ECS Service and Redis Cluster will be deployed
  # These will correspond to the two Private Subnets that are pre-existing within the spoke
  subnet_ids_list = {
    dev  = ["subnet-111", "subnet-11"] 
    prod = ["subnet-111", "subnet-111", "subnet-1111"]
  }

  # The VPC ID where the ECS Service and Redis Cluster will be deployed
  # This is pre-existing within the spoke and can be found by navigating the the VPC area within your spoke
  vpc_id_list = {
    dev  = "vpc-111" # Name - 
    prod = "vpc-111" # Name - 
  }

  enable_load_balancer_list = {
    dev  = true
    prod = true
  }

  load_balancer_http_redirect_list = {
    dev  = true
    prod = true
  }

  target_group_health_check_enabled_list = {
    dev  = true
    prod = true
  }

  load_balancer_type_list = {
    dev  = "application"
    prod = "application"
  }

  load_balancer_listener_container_list = {
    dev  = "demo"
    prod = "demo"
  }

  load_balancer_listener_port_list = {
    dev  = 443
    prod = 443
  }

  load_balancer_listener_protocol_list = {
    dev  = "HTTPS"
    prod = "HTTPS"
  }

  # The name of the SSL Cert being attached to the load Balancer
  # This value can be found in the spoke account in the Amazon Certificate Manager section
  load_balancer_listener_ssl_cert_domain_list = {
    dev  = "*.dev.ip.demo.com"
    prod = "demo.ip.demo.net"
  }

  load_balancer_listener_ssl_policy_list = {
    dev  = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
    prod = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  }

  # The listen port for the application
  load_balancer_target_port_list = {
    dev  = 8100
    prod = 8100
  }

  # The protocol that the listener is using
  load_balancer_target_protocol_list = {
    dev  = "HTTP"
    prod = "HTTP"
  }

  # DNS name for the application. This record will be created
  dns_name_list = {
    dev  = "dev-demo.dev.ip.demo.com"
    prod = "demo.prod.ip.demo.net"
  }

  # Route 53 Zone ID, this can be found in the spoke
  route_53_zone_id_list = {
    dev  = "111"
    prod = "111"
  }

  app_task_role_policies                 = lookup(local.app_task_role_policies_list, local.env)
  kms_data_alias                         = lookup(local.kms_data_alias_list, local.env)
  demo_secret_name                     = lookup(local.demo_secret_name_list, local.env)
  demo2_secret_name                     = lookup(local.demo2_secret_name_list, local.env)
  ifi_secret_name                        = lookup(local.ifi_secret_name_list, local.env)
  secret_key_secret_name                 = lookup(local.secret_key_secret_name_list, local.env)
  security_group_names                   = lookup(local.security_group_names_list, local.env)
  service_desired_count                  = lookup(local.service_desired_count_list, local.env)
  shared_tags                            = lookup(local.shared_tags_list, local.env)
  subnet_ids                             = lookup(local.subnet_ids_list, local.env)
  vpc_id                                 = lookup(local.vpc_id_list, local.env)
  enable_load_balancer                   = lookup(local.enable_load_balancer_list, local.env)
  load_balancer_type                     = lookup(local.load_balancer_type_list, local.env)
  load_balancer_http_redirect            = lookup(local.load_balancer_http_redirect_list, local.env)
  target_group_health_check_enabled      = lookup(local.target_group_health_check_enabled_list, local.env)
  load_balancer_listener_container       = lookup(local.load_balancer_listener_container_list, local.env)
  load_balancer_listener_port            = lookup(local.load_balancer_listener_port_list, local.env)
  load_balancer_listener_protocol        = lookup(local.load_balancer_listener_protocol_list, local.env)
  load_balancer_listener_ssl_cert_domain = lookup(local.load_balancer_listener_ssl_cert_domain_list, local.env)
  load_balancer_listener_ssl_policy      = lookup(local.load_balancer_listener_ssl_policy_list, local.env)
  load_balancer_target_port              = lookup(local.load_balancer_target_port_list, local.env)
  load_balancer_target_protocol          = lookup(local.load_balancer_target_protocol_list, local.env)
  dns_name                               = lookup(local.dns_name_list, local.env)
  route_53_zone_id                       = lookup(local.route_53_zone_id_list, local.env)
}
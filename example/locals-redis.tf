locals {
  # Redis Engine Version
  engine_version_list = {
    dev  = "6.x"
    prod = "6.x"
  }

  # Redis Parameter Group values.
  # These are AWS default parameter groups and handle most installations
  parameter_group_list = {
    dev  = "default.redis6.x"
    prod = "default.redis6.x"
  }

  # The type of nodes to be used for this Redis Cluster
  # Defaulting to small and upgrading as needed
  redis_node_type_list = {
    dev  = "cache.t3.small"
    prod = "cache.t3.small"
  }

  # Listen port for Redis Cluster. 6379 is the well known port for Redis
  redis_port_list = {
    dev  = 6379
    prod = 6379
  }

  # Secret name in which Redis Auth Key/Password will be stored in.
  # There is no set naming convention here, however we are using ENV/APP/VALUE
  redis_secret_name_list = {
    dev  = "dev/demo/redis"
    prod = "prod/demo/redis"
  }

  redis_subnets_list = {
    dev  = ["subnet-111", "subnet-111"]
    prod = ["subnet-111", "subnet-111"]
  }

  engine_version    = lookup(local.engine_version_list, local.env)
  parameter_group   = lookup(local.parameter_group_list, local.env)
  redis_node_type   = lookup(local.redis_node_type_list, local.env)
  redis_port        = lookup(local.redis_port_list, local.env)
  redis_secret_name = lookup(local.redis_secret_name_list, local.env)
  redis_subnets     = lookup(local.redis_subnets_list, local.env)
}
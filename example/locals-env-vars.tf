locals {
  # This contains all non-secitive configuration for the app
  # This needs to be added for all environments
  # REDIS_HOST is derived from the endpoint of the redis cluster created by the Terraform
  environment_variables_list = {
    dev = [
      {
        name  = "DJANGO_SETTINGS_MODULE"
        value = "demo.settings.aws_dev"
      },
      {
        name  = "DISABLE_COLLECTSTATIC"
        value = "1"
      },
      {
        name  = "REDIS_HOST"
        value = module.redis.redis_endpoint
      },
      {
        name  = "REDIS_PORT"
        value = "6379"
      },
      {
        name = "DEMO_HOST"
        value = one(module.postgres[*].address)
      },
      {
        name = "DEMO2_HOST"
        value = one(module.postgres[*].address)
      },
      {
        name = "DEMO_PORT"
        value = tostring(one(module.postgres[*].port))
      },
      {
        name = "DEMO2_PORT"
        value = tostring(one(module.postgres[*].port))
      }
    ]
    prod = [
     {
        name  = "DJANGO_SETTINGS_MODULE"
        value = "demo.settings.aws_prod"
      },
      {
        name  = "DISABLE_COLLECTSTATIC"
        value = "1"
      },
      {
        name  = "REDIS_HOST"
        value = module.redis.redis_endpoint
      },
      {
        name  = "REDIS_PORT"
        value = "6379"
      },
      {
        name = "PDEMO_HOST"
        value = one(module.postgres[*].address)
      },
      {
        name = "PDEMO2_HOST"
        value = one(module.postgres[*].address)
      },
      {
        name = "PDEMO_PORT"
        value = tostring(one(module.postgres[*].port))
      },
      {
        name = "PDEMO2_PORT"
        value = tostring(one(module.postgres[*].port))
      }
    ]
  }

  # These are sensitive environment variables
  # These values are contained within secrets manager
  # Reference the ARN of the secret in the valueFrom field
  # ECS will pull in these values and pull them into the container
  secrets_list = {
    dev = [
      {
        name      = "DEMO_PASSWORD"
        valueFrom = one(data.aws_secretsmanager_secret.rds_db[*].arn)
      },
      {
        name      = "DEMO2_PASSWORD"
        valueFrom = one(data.aws_secretsmanager_secret.rds_db[*].arn)
      },
      {
        name      = "IFI_PASSWORD"
        valueFrom = data.aws_secretsmanager_secret.ifi.arn
      },
      {
        name      = "REDIS_PASSWORD"
        valueFrom = data.aws_secretsmanager_secret.redis_auth.arn
      },
      {
        name      = "SECRET_KEY"
        valueFrom = data.aws_secretsmanager_secret.secret_key.arn
      },
    ]
    prod = [
      {
        name      = "PDEMO_PASSWORD"
        valueFrom = one(data.aws_secretsmanager_secret.rds_db[*].arn)
      },
      {
        name      = "PDEMO2_PASSWORD"
        valueFrom = one(data.aws_secretsmanager_secret.rds_db[*].arn)
      },
      {
        name      = "IFI_PASSWORD"
        valueFrom = data.aws_secretsmanager_secret.ifi.arn
      },
      {
        name      = "REDIS_PASSWORD"
        valueFrom = data.aws_secretsmanager_secret.redis_auth.arn
      },
      {
        name      = "SECRET_KEY"
        valueFrom = data.aws_secretsmanager_secret.secret_key.arn
      },
    ]
  }

  environment_variables = lookup(local.environment_variables_list, local.env)
  secrets               = lookup(local.secrets_list, local.env)
}
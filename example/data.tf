data "aws_region" "current" {}

data "aws_kms_key" "main" {
  key_id = "alias/${local.kms_data_alias}"
}

data "aws_acm_certificate" "main" {
  domain      = local.load_balancer_listener_ssl_cert_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_secretsmanager_secret" "demo" {
  name = local.demo_secret_name
}

data "aws_secretsmanager_secret" "demo" {
  name = local.demo_secret_name
}

data "aws_secretsmanager_secret" "ifi" {
  name = local.ifi_secret_name
}

data "aws_secretsmanager_secret" "redis_auth" {
  name = local.redis_secret_name
}

data "aws_secretsmanager_secret" "secret_key" {
  name = local.secret_key_secret_name
}

data "aws_secretsmanager_secret" "rds_db" {
  count = local.db_admin_secret != null ? 1 : 0

  name = local.db_admin_secret
}

data "aws_iam_policy" "kms_access" {
  name = "DemoKMSAccess"
}

data "aws_iam_policy" "secret_manager_read_access" {
  name = "DemoSecretsReadAccess"
}

data "aws_iam_policy" "cloud_watch_read_access" {
  name = "DemoCloudWatchReadAccess"
}

data "aws_iam_policy" "cloud_watch_write_access" {
  name = "DemoCloudWatchWriteAccess"
}
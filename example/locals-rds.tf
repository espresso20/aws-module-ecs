locals {
  db_enabled_list = {
    dev  = true
    prod = true
  }

  db_storage_list = {
    dev  = 60
    prod = 120
  }

  db_admin_secret_list = {
    dev  = "dev/demo/db-admin-password"
    prod = "prod/demo/db-admin-password"
  }

  db_engine_version_list = {
    dev  = "12.11"
    prod = "12.11"
  }

  db_major_engine_version_list = {
    dev = "12"
    prod = "12"
  }

  db_instance_class_list = {
    dev  = "db.t3.medium"
    prod = "db.t3.medium"
  }

  db_instance_name_list = {
    dev  = "demo-dev"
    prod = "demo-production"
  }

  db_database_name_list = {
    dev  = "dlegio1"
    prod = "plegio1"
  }

  db_option_group_name_list = {
    dev  = "default:postgres-12"
    prod = "default:postgres-12"
  }

  db_parameter_group_name_list = {
    dev  = "default.postgres12"
    prod = "default.postgres12"
  }

  db_username_list = {
    dev  = "demo"
    prod = "demo"
  }

  db_security_group_ids_list = {
    dev  = ["sg-111", "sg-111"] 
    prod = ["sg-111", "sg-111"]
  }

  db_multi_az_list = {
    dev  = false
    prod = true
  }

  db_apply_immediately_list = {
    dev  = true
    prod = true
  }


  db_backup_retention_period_list = {
    dev  = 7
    prod = 35
  }

  db_preferred_backup_window_list = {
    dev  = "05:00-05:30"
    prod = "05:00-05:30"
  }

  db_deletion_protection_list = {
    dev  = true
    prod = true
  }

  db_storage_encrypted_list = {
    dev = true
    prod = true
  }

  db_enabled              = lookup(local.db_enabled_list, local.env)
  db_storage              = lookup(local.db_storage_list, local.env)
  db_admin_secret         = lookup(local.db_admin_secret_list, local.env)
  db_engine_version       = lookup(local.db_engine_version_list, local.env)
  db_major_engine_version = lookup(local.db_major_engine_version_list, local.env)
  db_instance_class       = lookup(local.db_instance_class_list, local.env)
  db_database_name        = lookup(local.db_database_name_list, local.env)
  db_instance_name        = lookup(local.db_instance_name_list, local.env)
  db_option_group_name    = lookup(local.db_option_group_name_list, local.env)
  db_parameter_group_name = lookup(local.db_parameter_group_name_list, local.env)
  db_username             = lookup(local.db_username_list, local.env)
  db_security_group_ids   = lookup(local.db_security_group_ids_list, local.env)
  db_multi_az             = lookup(local.db_multi_az_list, local.env)
  db_apply_immediately    = lookup(local.db_apply_immediately_list, local.env)
  db_backup_retention_period = lookup(local.db_backup_retention_period_list, local.env)
  db_preferred_backup_window = lookup(local.db_preferred_backup_window_list, local.env)
  db_deletion_protection     = lookup(local.db_deletion_protection_list, local.env)
  db_storage_encrypted = lookup(local.db_storage_encrypted_list, local.env)
}
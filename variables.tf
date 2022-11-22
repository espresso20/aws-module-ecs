variable "cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
}

variable "datadog_forwarder_filter_pattern" {
  default     = ""
  description = "Filter Pattern for Cloudwatch log forwarder"
  type        = string
}

variable "datadog_forwarder_lambda_arn" {
  default     = ""
  description = "AWS ARN of the lambda function to handle forwarding logs"
  type        = string
}

variable "ecs_service_definitions" {
  default     = {}
  description = "Map of ECS Services"
  type = map(object({
    name                  = string
    task                  = string
    desired_count         = number
    launch_type           = string
    wait_for_steady_state = bool
    security_groups       = list(string)
    subnets               = list(string)
    assign_public_ip      = bool
  }))
}

variable "ecs_task_definitions" {
  default     = {}
  description = "Map of task definitions"
  type = map(object({
    family                   = string
    container_definitions    = string
    requires_compatibilities = list(string)
    cpu                      = number
    memory                   = number
    network_mode             = string
    execution_role_arn       = string
    task_role_arn            = string
  }))
}

variable "enable_datadog_cloudwatch" {
  default     = false
  description = "Flag to enable the forwarding of cloudwatch logs to datadog"
  type        = bool
}

variable "enable_load_balancer" {
  default     = false
  description = "When set to true, a network load balancer will be created and attached to the ECS service"
  type        = bool
}

variable "load_balancer_deregistration_delay" {
  default     = 60
  description = "Amount of sections to way to degregister draining instances"
  type        = number
}

variable "load_balancer_http_redirect" {
  default     = false
  description = "Redirect HTTP traffic to HTTPS (Only works with application load balancer)"
  type        = bool
}

variable "load_balancer_listener_container" {
  default     = null
  description = "Name of the container to direct load balancer"
  type        = string
}

variable "load_balancer_listener_port" {
  default     = null
  description = "Listener port for load balancer"
  type        = number
}

variable "load_balancer_listener_protocol" {
  default     = "TCP"
  description = "Listener protocol for load balancer"
  type        = string
}

variable "load_balancer_listener_ssl_cert" {
  default     = null
  description = "ARN of the SSL Certificate to apply to the listener. Only Applicable for HTTPS Protocol"
  type        = string
}

variable "load_balancer_listener_ssl_policy" {
  default     = null
  description = "SSL Policy to apply to the listener. Only Applicable for HTTPS Protocol (Example `ELBSecurityPolicy-2016-08`)"
  type        = string
}

variable "load_balancer_target_port" {
  default     = null
  description = "Target port for load balancer (Port that the containerized service is listening on)"
  type        = number
}

variable "load_balancer_target_protocol" {
  default     = "HTTP"
  description = "Target protocol for load balancer"
  type        = string
}

variable "load_balancer_type" {
  default     = "network"
  description = "Type of load balancer, valid types `application` (ALB), `network` (NLB)"
  type        = string

  validation {
    condition     = contains(["network", "application", null], var.load_balancer_type)
    error_message = "The load_balancer_type value must be either application, network, or null."
  }
}

variable "retnetion_days" {
  default     = 5
  description = "Number of days to retain logs"
  type        = number
}

variable "shared_tags" {
  default     = {}
  description = "Map of tags to be applied to ECS Cluster and it's associated resources"
  type        = map(any)
}

variable "target_group_health_check_enabled" {
  default     = true
  description = "Enable Target Group Health Check."
  type        = bool
}

variable "target_group_health_check_healthy_threshold" {
  default     = 3
  description = "Number of consecutive health check fails before an unhealthy service is considered healthy"
  type        = number
}

variable "target_group_health_check_interval" {
  default     = 30
  description = "Amount of time, in seconds, between health checks."
  type        = number
}

variable "target_group_health_check_response_codes" {
  default     = null
  description = "Valid Response Codes for Target Group Health Check."
  type        = string
}

variable "target_group_health_check_timeout" {
  default     = 6
  description = "Amount of time, in seconds, before a timeout occurs for health check."
  type        = number
}

variable "target_group_health_check_unhealthy_threshold" {
  default     = 3
  description = "Number of consecutive health check fails before a service is considered unhealthy"
  type        = number
}

variable "vpc_id" {
  description = "VPC ID to deploy ECS in"
  type        = string
}

resource "aws_cloudwatch_log_group" "main" {
  name              = var.cluster_name
  tags              = var.shared_tags
  retention_in_days = var.retnetion_days
}

resource "aws_cloudwatch_log_subscription_filter" "datadog" {
  count = var.enable_datadog_cloudwatch ? 1 : 0

  name            = "${var.cluster_name}-datadog"
  log_group_name  = aws_cloudwatch_log_group.main.name
  destination_arn = var.datadog_forwarder_lambda_arn
  filter_pattern  = var.datadog_forwarder_filter_pattern
}

resource "aws_lb" "main" {
  count = var.enable_load_balancer ? 1 : 0

  name               = "${var.cluster_name}-lb"
  internal           = true
  load_balancer_type = var.load_balancer_type
  subnets            = local.combined_subnets
  security_groups    = var.load_balancer_type == "application" ? local.combined_security_groups : null

  tags = merge(
    var.shared_tags,
    {
      Name        = "${var.cluster_name}-lb"
      Description = "Load balancer for ${var.cluster_name} ECS Cluster"
    }
  )
}

resource "aws_lb_target_group" "main" {
  count = var.enable_load_balancer ? 1 : 0

  name                 = "${var.cluster_name}-lb-tg"
  port                 = var.load_balancer_target_port
  protocol             = var.load_balancer_target_protocol
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = var.load_balancer_deregistration_delay

  health_check {
    enabled             = var.target_group_health_check_enabled
    matcher             = var.target_group_health_check_response_codes
    healthy_threshold   = var.target_group_health_check_healthy_threshold
    interval            = var.target_group_health_check_interval
    timeout             = var.target_group_health_check_timeout
    unhealthy_threshold = var.target_group_health_check_unhealthy_threshold
  }
}

resource "aws_lb_listener" "main" {
  count = var.enable_load_balancer ? 1 : 0

  load_balancer_arn = aws_lb.main[0].arn
  port              = var.load_balancer_listener_port
  protocol          = var.load_balancer_listener_protocol
  ssl_policy        = var.load_balancer_listener_ssl_policy
  certificate_arn   = var.load_balancer_listener_ssl_cert

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }

  depends_on = [
    aws_lb_target_group.main
  ]
}

resource "aws_lb_listener" "http_redirect" {
  count = alltrue([var.enable_load_balancer, var.load_balancer_http_redirect]) ? 1 : 0

  load_balancer_arn = aws_lb.main[0].arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  depends_on = [
    aws_lb_target_group.main
  ]
}

resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  tags = merge(
    var.shared_tags,
    {
      Name        = var.cluster_name
      Description = "ECS Cluster for ${var.cluster_name}"
    }
  )
}

resource "aws_ecs_task_definition" "main" {
  for_each = var.ecs_task_definitions

  family                   = each.value.family
  container_definitions    = each.value.container_definitions
  requires_compatibilities = each.value.requires_compatibilities
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  network_mode             = each.value.network_mode
  execution_role_arn       = each.value.execution_role_arn
  task_role_arn            = each.value.task_role_arn

  tags = merge(
    var.shared_tags,
    {
      Name        = var.cluster_name
      Description = "ECS Service for ${var.cluster_name} - ${each.key}"
    }
  )
}

resource "aws_ecs_service" "main" {
  for_each = var.ecs_service_definitions

  name                  = each.value.name
  task_definition       = "${aws_ecs_task_definition.main[each.value.task].family}:${max(aws_ecs_task_definition.main[each.value.task].revision, data.aws_ecs_task_definition.main[each.value.task].revision)}"
  desired_count         = each.value.desired_count
  launch_type           = each.value.launch_type
  cluster               = aws_ecs_cluster.main.id
  wait_for_steady_state = each.value.wait_for_steady_state

  network_configuration {
    security_groups  = data.aws_security_groups.main[each.key].ids
    subnets          = each.value.subnets
    assign_public_ip = each.value.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.enable_load_balancer ? [1] : []
    content {
      target_group_arn = aws_lb_target_group.main[0].arn
      container_name   = var.load_balancer_listener_container
      container_port   = var.load_balancer_target_port
    }
  }

  tags = merge(
    var.shared_tags,
    {
      Name        = each.value.name
      Description = "ECS Service for ${var.cluster_name} - ${each.value.name}"
    }
  )
}
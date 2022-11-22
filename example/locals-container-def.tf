locals {
  # This is the ECS container definition.
  # It is fed the image that is built during the Docker build step
  # It contains the start command
  # This definition should be able to be used across all environments
  container_definitions = jsonencode([
    {
      name  = "demo"
      image = var.demo_task_image
      command = [
        "gunicorn",
        "--timeout",
        "120",
        "--pythonpath",
        "./demo/",
        "--bind",
        "0.0.0.0:8100",
        "demo.wsgi:application"
      ]
      memory      = 2048
      networkMode = "awsvpc"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = local.cluster_name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
      portMappings = [
        {
          hostPort      = 8100
          containerPort = 8100
          protocol      = "tcp"
        }
      ]
      environment = local.environment_variables
      secrets     = local.secrets
    }
  ])
}
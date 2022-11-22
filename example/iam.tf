data "aws_iam_policy_document" "demo_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "ecs.amazonaws.com",
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "demo_execution_role" {
  name                  = "${local.demo_worker_name}-exec"
  description           = "execution role for demo Worker ECS Task"
  path                  = "/"
  force_detach_policies = false

  assume_role_policy = data.aws_iam_policy_document.demo_assume_role.json

  tags = local.shared_tags
}

resource "aws_iam_role_policy_attachment" "kms_access" {
  role       = aws_iam_role.demo_execution_role.name
  policy_arn = data.aws_iam_policy.kms_access.arn
}

resource "aws_iam_role_policy_attachment" "secret_manager_read_access" {
  role       = aws_iam_role.demo_execution_role.name
  policy_arn = data.aws_iam_policy.secret_manager_read_access.arn
}

resource "aws_iam_role_policy_attachment" "cloud_watch_read_access" {
  role       = aws_iam_role.demo_execution_role.name
  policy_arn = data.aws_iam_policy.cloud_watch_read_access.arn
}

resource "aws_iam_role_policy_attachment" "cloud_watch_write_access" {
  role       = aws_iam_role.demo_execution_role.name
  policy_arn = data.aws_iam_policy.cloud_watch_write_access.arn
}
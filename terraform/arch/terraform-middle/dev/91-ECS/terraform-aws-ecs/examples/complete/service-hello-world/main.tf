resource "aws_cloudwatch_log_group" "this" {
  name_prefix       = "ecsTest_hello_world-"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "this" {
  family = "ecsTest_hello_world"

  container_definitions = <<EOF
[
  {
    "name": "ecsTest_hello_world",
    "image": "hello-world",
    "cpu": 0,
    "memory": 128,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "eu-west-1",
        "awslogs-group": "${aws_cloudwatch_log_group.this.name}",
        "awslogs-stream-prefix": "ec2"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "this" {
  name            = "ecsTest_hello_world"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}

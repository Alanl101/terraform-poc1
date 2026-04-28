resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/poc-task"
  retention_in_days = 7
}
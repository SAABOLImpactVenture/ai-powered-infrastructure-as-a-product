resource "aws_cloudwatch_log_group" "default" {
  name              = "/platform/default"
  retention_in_days = 90
  kms_key_id        = null
}

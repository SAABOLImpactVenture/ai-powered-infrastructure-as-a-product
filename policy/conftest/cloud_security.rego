package cloud.security

deny[msg] {
  input.resource_type == "aws_iam_policy"
  some i
  input.document.Statement[i].Action == "*"
  msg = "IAM policy allows '*' actions"
}

deny[msg] {
  input.resource_type == "aws_s3_bucket_policy"
  some i
  input.document.Statement[i].Principal == "*"
  msg = "S3 bucket policy allows public principal"
}

deny[msg] {
  input.resource_type == "aws_security_group_rule"
  input.cidr == "0.0.0.0/0"
  input.port == 22
  msg = "Security Group allows SSH from 0.0.0.0/0"
}

deny[msg] {
  input.resource_type == "tls_policy"
  lt(input.min_version, "TLS1.2")
  msg = "TLS minimum version less than 1.2"
}

output "DB_instance_id" {
  description = "The endpoint of the RDS instance."
  value       = aws_db_instance.database.endpoint
}

output "port" {
  description = "The port of the RDS instance."
  value       = aws_db_instance.database.port
}

output "username" {
  description = "The username for the RDS instance."
  value       = aws_db_instance.database.username
}

output "password" {
  description = "The password for the RDS instance."
  value       = aws_db_instance.database.password
  sensitive   = true
}

data "aws_caller_identity" "current" {}

output "account_id" {
  description = "The AWS account ID."
  value       = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  description = "The ARN of the caller."
  value       = data.aws_caller_identity.current.arn
}

output "caller_user" {
  description = "The user ID of the caller."
  value       = data.aws_caller_identity.current.user_id
}

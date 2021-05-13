output "DB_instance_id" {
  description = "Endpoint. "
  value = aws_db_instance.database.endpoint
}

output "port" {
  description = "Port. "
  value = aws_db_instance.database.port
}

output "username" {
  description = "Username. "
  value = aws_db_instance.database.username
}

output "password" {
  description = "Password. "
  value = aws_db_instance.database.password
  sensitive = true
}


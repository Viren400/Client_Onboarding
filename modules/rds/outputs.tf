output "rds_endpoint" {
  value = try(aws_db_instance.this[0].endpoint, null)
}

output "rds_port" {
  value = try(aws_db_instance.this[0].port, null)
}

output "rds_identifier" {
  value = try(aws_db_instance.this[0].identifier, null)
}
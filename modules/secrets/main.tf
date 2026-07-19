locals {

  name_prefix = "${var.client_name}-${var.environment}"

}

resource "aws_secretsmanager_secret" "db" {

  name = "${local.name_prefix}-db-secret"

  description = "Database Credentials"

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-db-secret"
    }
  )

}

resource "aws_secretsmanager_secret_version" "db" {

  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({

    username = var.db_username

    password = var.db_password

  })

}


locals {

  name_prefix = "${var.client_name}-${var.environment}"

}

resource "aws_db_subnet_group" "this" {

  count = var.create_rds ? 1 : 0

  name = "${local.name_prefix}-db-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-db-subnet-group"
    }
  )

}
resource "aws_db_instance" "this" {

  count = var.create_rds ? 1 : 0

  identifier = "${local.name_prefix}-mysql"

  allocated_storage = var.db_allocated_storage

  engine = var.db_engine

  engine_version = var.db_engine_version

  instance_class = var.db_instance_class

  username = var.db_username

  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.this[0].name

  vpc_security_group_ids = [
    var.rds_security_group_id
  ]

  multi_az = var.multi_az

  backup_retention_period = var.backup_retention_period

  publicly_accessible = false

  skip_final_snapshot = true

  deletion_protection = false

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-mysql"
    }
  )

}

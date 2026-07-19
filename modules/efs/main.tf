locals {

  name_prefix = "${var.client_name}-${var.environment}"

}
resource "aws_efs_file_system" "this" {

  creation_token = "${local.name_prefix}-efs"

  encrypted = true

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-efs"
    }
  )

}

resource "aws_efs_mount_target" "az1" {

  file_system_id = aws_efs_file_system.this.id

  subnet_id = var.private_subnet_ids[0]

  security_groups = [

    var.efs_security_group_id

  ]

}

resource "aws_efs_mount_target" "az2" {

  file_system_id = aws_efs_file_system.this.id

  subnet_id = var.private_subnet_ids[1]

  security_groups = [

    var.efs_security_group_id

  ]

}
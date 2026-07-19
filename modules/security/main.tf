locals {

  name_prefix = "${var.client_name}-${var.environment}"

}

resource "aws_security_group" "ec2" {

  name = "${local.name_prefix}-ec2-sg"

  description = "EC2 Security Group"

  vpc_id = var.vpc_id

  ingress {

    description = "SSH"

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = [var.allowed_ssh_cidr]

  }

  ingress {

    description = "HTTP"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = [var.allowed_ssh_cidr]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [var.allowed_ssh_cidr]

  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-ec2-sg"
    }
  )

}

resource "aws_security_group" "alb" {

  name = "${local.name_prefix}-alb-sg"

  description = "ALB Security Group"

  vpc_id = var.vpc_id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = [var.allowed_ssh_cidr]

  }

  ingress {

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = [var.allowed_ssh_cidr]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [var.allowed_ssh_cidr]

  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-alb-sg"
    }
  )

}

resource "aws_security_group" "rds" {

  name = "${local.name_prefix}-rds-sg"

  description = "RDS Security Group"

  vpc_id = var.vpc_id

  ingress {

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    security_groups = [
      aws_security_group.ec2.id
    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [var.allowed_ssh_cidr]

  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-rds-sg"
    }
  )

}

resource "aws_security_group" "efs" {

  name = "${local.name_prefix}-efs-sg"

  description = "EFS Security Group"

  vpc_id = var.vpc_id

  ingress {

    from_port = 2049

    to_port = 2049

    protocol = "tcp"

    security_groups = [
      aws_security_group.ec2.id
    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [var.allowed_ssh_cidr]

  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-efs-sg"
    }
  )

}
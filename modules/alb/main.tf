locals {

  name_prefix = "${var.client_name}-${var.environment}"

}

resource "aws_lb" "this" {

  name = "${local.name_prefix}-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = var.public_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-alb"
    }
  )

}

resource "aws_lb_target_group" "this" {

  name = "${local.name_prefix}-tg"

  port = 80

  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {

    path = "/"

    protocol = "HTTP"

    matcher = "200"

  }

}

resource "aws_lb_target_group_attachment" "this" {

  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.this.arn

  target_id = var.instance_ids[count.index]

  port = 80

}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.this.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.this.arn

  }

}

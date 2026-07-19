data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {

    name = "name"

    values = ["al2023-ami-*-x86_64"]

  }

}

locals {

  name_prefix = "${var.client_name}-${var.environment}"

}

resource "aws_instance" "this" {

  count = var.instance_count

  ami = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  #subnet_id = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  subnet_id = var.public_subnet_ids[count.index % length(var.public_subnet_ids)]

  vpc_security_group_ids = [

    var.ec2_security_group_id

  ]

  key_name = var.key_name

  tags = merge(

    var.common_tags,

    {

      Name = "${local.name_prefix}-ec2-${count.index + 1}"

    }

  )

  user_data = templatefile("${path.module}/userdata.sh", {
    client_name = var.client_name
  })

}


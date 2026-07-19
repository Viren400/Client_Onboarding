###############################################################
# Local Variables
###############################################################

locals {

  #############################################################
  # Naming Convention
  #############################################################

  name_prefix = "${var.client_name}-${var.environment}"

  #############################################################
  # Every Client gets one /24 Network
  #
  # Client 1  -> 10.0.1.0/24
  # Client 2  -> 10.0.2.0/24
  #############################################################

  vpc_cidr = cidrsubnet("10.0.0.0/8", 16, var.client_index)

  #############################################################
  # Split /24 into four /26 subnets
  #############################################################

  public_subnet_1 = cidrsubnet(local.vpc_cidr, 2, 0)
  public_subnet_2 = cidrsubnet(local.vpc_cidr, 2, 1)

  private_subnet_1 = cidrsubnet(local.vpc_cidr, 2, 2)
  private_subnet_2 = cidrsubnet(local.vpc_cidr, 2, 3)

}

###############################################################
# Get Available AZs
###############################################################

data "aws_availability_zones" "available" {}

###############################################################
# VPC
###############################################################

resource "aws_vpc" "this" {

  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-vpc"
    }
  )
}

###############################################################
# Internet Gateway
###############################################################

resource "aws_internet_gateway" "this" {

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-igw"
    }
  )

}

###############################################################
# Public Subnet 1
###############################################################

resource "aws_subnet" "public_1" {

  vpc_id = aws_vpc.this.id

  cidr_block = local.public_subnet_1

  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-public-subnet-1"
    }
  )

}

###############################################################
# Public Subnet 2
###############################################################

resource "aws_subnet" "public_2" {

  vpc_id = aws_vpc.this.id

  cidr_block = local.public_subnet_2

  availability_zone = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-public-subnet-2"
    }
  )

}

###############################################################
# Private Subnet 1
###############################################################

resource "aws_subnet" "private_1" {

  vpc_id = aws_vpc.this.id

  cidr_block = local.private_subnet_1

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-private-subnet-1"
    }
  )

}

###############################################################
# Private Subnet 2
###############################################################

resource "aws_subnet" "private_2" {

  vpc_id = aws_vpc.this.id

  cidr_block = local.private_subnet_2

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-private-subnet-2"
    }
  )

}

#############################################
# Public Route Table
#############################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.this.id

  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-public-rt"
    }
  )

}


#############################################
# Private Route Table
#############################################

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-private-rt"
    }
  )

}

resource "aws_route_table_association" "public_1" {

  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public_2" {

  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id

}


resource "aws_route_table_association" "private_1" {

  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private_2" {

  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id

}
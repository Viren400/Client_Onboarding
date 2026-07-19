output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = local.vpc_cidr
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}
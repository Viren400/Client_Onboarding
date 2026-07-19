variable "client_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "key_name" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ec2_security_group_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "public_subnet_ids" {
  type = list(string)
}
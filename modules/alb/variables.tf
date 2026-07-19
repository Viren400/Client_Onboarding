variable "client_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "instance_ids" {
  type = list(string)
}

variable "common_tags" {
  type = map(string)
}
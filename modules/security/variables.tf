variable "client_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "allowed_ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
variable "client_name" {

  description = "Client Name"

  type = string

}

variable "environment" {

  description = "Environment"

  type = string

}

variable "aws_region" {

  description = "AWS Region"

  type = string

}

variable "client_index" {

  description = "Unique Client Number"

  type = number

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

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
variable "create_rds" {
  type    = bool
  default = false
}

variable "db_instance_class" {
  type = string
}

variable "db_allocated_storage" {
  type = number
}

variable "multi_az" {
  type = bool
}

variable "backup_retention_period" {
  type = number
}

variable "create_alb" {
  type    = bool
  default = false
}

variable "create_efs" {
  type    = bool
  default = false
}

variable "create_nat_gateway" {
  type    = bool
  default = false
}

variable "db_engine" {
  type = string
}

variable "db_engine_version" {
  type = string
}
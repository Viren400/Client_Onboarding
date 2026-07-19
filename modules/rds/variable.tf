variable "client_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "rds_security_group_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "create_rds" {
  type = bool
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
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

variable "db_engine" {
  type = string
}

variable "db_engine_version" {
  type = string
}
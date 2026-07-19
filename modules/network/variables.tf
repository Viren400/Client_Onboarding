variable "client_name" {
  description = "Client Name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "client_index" {
  description = "Unique Client Index"
  type        = number
}

variable "common_tags" {
  description = "Common Tags"
  type        = map(string)
}
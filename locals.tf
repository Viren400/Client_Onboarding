locals {

  ##########################################################
  # Resource Naming
  ##########################################################

  name_prefix = "${var.client_name}-${var.environment}"

  ##########################################################
  # Common Tags
  ##########################################################

  common_tags = {

    Client = var.client_name

    Environment = var.environment

    ManagedBy = "Terraform"

    Project = "Client-Onboarding"

  }

}
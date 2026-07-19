# terraform {

#   backend "s3" {

#     bucket = "xxxx"

#     key = "client-onboarding/terraform.tfstate"

#     region = "us-east-2"

#     dynamodb_table = "terraform-lock"

#   }

# }
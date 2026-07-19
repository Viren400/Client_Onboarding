module "network" {

  source = "./modules/network"

  client_name = var.client_name

  environment = var.environment

  client_index = var.client_index

  common_tags = local.common_tags

}



module "security" {

  source = "./modules/security"

  client_name = var.client_name

  environment = var.environment

  vpc_id = module.network.vpc_id

  common_tags = local.common_tags

}

module "compute" {

  source = "./modules/compute"

  client_name = var.client_name

  environment = var.environment

  instance_type = var.instance_type

  instance_count = var.instance_count

  key_name = var.key_name

  private_subnet_ids = module.network.private_subnet_ids

  public_subnet_ids = module.network.public_subnet_ids

  ec2_security_group_id = module.security.ec2_sg_id

  common_tags = local.common_tags

}

module "alb" {

  count = var.create_alb ? 1 : 0

  source = "./modules/alb"

  client_name = var.client_name

  environment = var.environment

  vpc_id = module.network.vpc_id

  public_subnet_ids = module.network.public_subnet_ids

  alb_security_group_id = module.security.alb_sg_id

  instance_ids = module.compute.instance_ids

  common_tags = local.common_tags

}

module "rds" {

  source = "./modules/rds"

  create_rds = var.create_rds

  client_name = var.client_name

  environment = var.environment

  private_subnet_ids = module.network.private_subnet_ids

  rds_security_group_id = module.security.rds_sg_id

  db_username = var.db_username

  db_password = var.db_password

  db_instance_class = var.db_instance_class

  db_allocated_storage = var.db_allocated_storage

  multi_az = var.multi_az

  backup_retention_period = var.backup_retention_period

  common_tags = local.common_tags

  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version
}

module "secrets" {

  source = "./modules/secrets"

  client_name = var.client_name

  environment = var.environment

  db_username = var.db_username

  db_password = var.db_password

  common_tags = local.common_tags

}

module "efs" {

  source = "./modules/efs"

  client_name = var.client_name

  environment = var.environment

  private_subnet_ids = module.network.private_subnet_ids

  efs_security_group_id = module.security.efs_sg_id

  common_tags = local.common_tags

}

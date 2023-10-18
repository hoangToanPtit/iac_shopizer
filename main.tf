module "vpc" {
  source = "./modules/vpc"
}

module "ec2-instances" {
  source = "./modules/ec2"

  vpc-id                    = module.vpc.vpc_id
  backend_subnet_ids        = module.vpc.backend_subnet_ids
  database_subnet_ids       = module.vpc.database_subnet_ids
  default_security_group_id = module.vpc.default_security_group_id
  frontend_subnet_ids       = module.vpc.frontend_subnet_ids
  public_subnet_ids         = module.vpc.public_subnet_ids
}

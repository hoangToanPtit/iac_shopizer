module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  frontend_subnet_cidrs = var.frontend_subnet_cidrs
  backend_subnet_cidrs  = var.backend_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
}

module "elb" {
  source                = "./modules/load_balancer"
  vpc_id                = module.vpc.vpc_id
  frontend_subnet_cidrs = var.frontend_subnet_cidrs
  backend_subnet_cidrs  = var.backend_subnet_cidrs
  public_subnet_cidrs   = var.public_subnet_cidrs
  public_subnet_ids     = module.vpc.public_subnet_ids

  depends_on = [module.vpc]

}

module "ec2-instances" {
  source = "./modules/ec2"

  vpc-id                    = module.vpc.vpc_id
  backend_subnet_ids        = module.vpc.backend_subnet_ids
  database_subnet_ids       = module.vpc.database_subnet_ids
  default_security_group_id = module.vpc.default_security_group_id
  frontend_subnet_ids       = module.vpc.frontend_subnet_ids
  public_subnet_ids         = module.vpc.public_subnet_ids

  depends_on = [module.vpc, module.elb]
}




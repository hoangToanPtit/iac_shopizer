module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  frontend_subnet_cidrs = var.frontend_subnet_cidrs
  backend_subnet_cidrs  = var.backend_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs

}

module "elb" {
  source               = "./modules/load_balancer"
  vpc_id               = module.vpc.vpc_id
  backend_subnet_cidrs = var.backend_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  public_subnet_ids    = module.vpc.public_subnet_ids

  depends_on = [ module.vpc ]

}

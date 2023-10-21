module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = "172.20.0.0/16"
  public_subnet_cidrs   = ["172.20.1.0/24", "172.20.2.0/24"]
  frontend_subnet_cidrs = ["172.20.3.0/24", "172.20.4.0/24"]
  backend_subnet_cidrs  = ["172.20.5.0/24", "172.20.6.0/24"]
  database_subnet_cidrs = ["172.20.7.0/24"]

}
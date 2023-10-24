provider "aws" {
  region = var.aws-region
}

# VPC module
module "vpc" {
  source                = "./modules/vpc"
  vpc-cidr              = "172.20.0.0/16"
  public-subnet-cidrs   = ["172.20.1.0/24", "172.20.2.0/24"]
  frontend-subnet-cidrs = ["172.20.3.0/24", "172.20.4.0/24"]
  backend-subnet-cidrs  = ["172.20.5.0/24", "172.20.6.0/24"]
  database-subnet-cidrs = ["172.20.7.0/24"]
  ssh-key-name          = "keypair-l2"
  nat-ami               = "ami-04106ae1c90766385"
}

# Bastion module
module "bastion" {
  source            = "./modules/bastion"
  default-name      = "shopizer"
  vpc-id            = module.vpc.vpc-id
  public-subnet-ids = module.vpc.public-subnet-ids
  ubuntu-ami        = "ami-0fc5d935ebf8bc3bc"

  depends_on = [module.vpc]
}

# Database module
module "database" {
  source               = "./modules/database"
  vpc-id               = module.vpc.vpc-id
  private-ip           = "172.20.7.47"
  database-subnet-ids  = module.vpc.database-subnet-ids
  ubuntu-ami           = "ami-0fc5d935ebf8bc3bc"
  nat-sg-id            = module.vpc.nat-sg-id
  bastion-sg-id        = module.bastion.bastion-sg-id
  backend-subnet-cidrs = module.vpc.backend-subnet-cidrs

  depends_on = [module.vpc, module.bastion]
}

# Backend module
module "backend" {
  source               = "./modules/backend"
  vpc-id               = module.vpc.vpc-id
  public-subnet-ids    = module.vpc.public-subnet-ids
  backend-subnet-ids   = module.vpc.backend-subnet-ids
  ubuntu-ami           = "ami-0fc5d935ebf8bc3bc"
  nat-sg-id            = module.vpc.nat-sg-id
  bastion-sg-id        = module.bastion.bastion-sg-id
  database-sg-id       = module.database.database-sg-id
  backend-subnet-cidrs = module.vpc.backend-subnet-cidrs

  depends_on = [module.vpc, module.bastion, module.database]
}

# Frontend module
module "frontend" {
  source                = "./modules/frontend"
  vpc-id                = module.vpc.vpc-id
  public-subnet-ids     = module.vpc.public-subnet-ids
  frontend-subnet-ids   = module.vpc.frontend-subnet-ids
  alb-be-dns            = module.backend.be-dns-name
  ubuntu-ami            = "ami-0fc5d935ebf8bc3bc"
  nat-sg-id             = module.vpc.nat-sg-id
  bastion-sg-id         = module.bastion.bastion-sg-id
  frontend-subnet-cidrs = module.vpc.frontend-subnet-cidrs

  depends_on = [module.vpc, module.bastion, module.backend]
}

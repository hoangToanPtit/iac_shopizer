provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = ["172.20.0.0/16"]
  public_subnet_cidrs   = ["172.20.1.0/24", "172.20.2.0/24"]
  frontend_subnet_cidrs = ["172.20.3.0/24", "172.20.4.0/24"]
  backend_subnet_cidrs  = ["172.20.5.0/24", "172.20.6.0/24"]
  database_subnet_cidrs = ["172.20.7.0/24"]
  ssh_key_name          = "keypair-l2"
  nat_ami               = "ami-04106ae1c90766385"
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

output "be_alb_dns" {
  value = module.elb.be_dns_name
}

output "fe_alb_dns" {
  value = module.elb.fe_dns_name
}

module "ec2-instances" {
  source = "./modules/ec2"

  vpc-id                    = module.vpc.vpc_id
  backend_subnet_ids        = module.vpc.backend_subnet_ids
  database_subnet_ids       = module.vpc.database_subnet_ids
  default_security_group_id = module.vpc.default_security_group_id
  frontend_subnet_ids       = module.vpc.frontend_subnet_ids
  public_subnet_ids         = module.vpc.public_subnet_ids
  alb_be_id                 = module.elb.be_alb_id
  alb_be_sg_id              = module.elb.be_alb_sg_id
  alb_be_arn                = module.elb.be_alb_arn
  alb_be_dns                = module.elb.be_dns_name

  alb_fe_id    = module.elb.fe_alb_id
  alb_fe_sg_id = module.elb.fe_alb_sg_id
  alb_fe_arn   = module.elb.fe_alb_arn
  alb_fe_dns   = module.elb.fe_dns_name

  ssh_key_name = "keypair-l2"
  ubuntu_ami   = "ami-0fc5d935ebf8bc3bc"

  depends_on = [module.vpc, module.elb]
}




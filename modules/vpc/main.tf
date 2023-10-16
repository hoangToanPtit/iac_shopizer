resource "aws_vpc" "shopzer-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "shopizer-vpc",
    Description = "VPC for creating Shopizer infrastructure resourece"
  }
}

#sabhasdhasd

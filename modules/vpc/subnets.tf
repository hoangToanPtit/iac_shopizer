data "aws_availability_zones" "available" {

}

# Public subnet
resource "aws_subnet" "public_subnet" {

  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.shopzer-vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name        = "public subnet ${count.index + 1} created by terraform",
    Description = "public subnet for shopizer"
  }

  depends_on = [aws_vpc.shopzer-vpc]
}

# Frontend subnet
resource "aws_subnet" "frontend_subnet" {

  count             = length(var.frontend_subnet_cidrs)
  vpc_id            = aws_vpc.shopzer-vpc.id
  cidr_block        = var.frontend_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "frontend subnet ${count.index + 1} created by terraform",
    Description = "frontend subnet for shopizer"
  }

  depends_on = [aws_vpc.shopzer-vpc]
}

# Backend subnet
resource "aws_subnet" "backend_subnet" {

  count             = length(var.backend_subnet_cidrs)
  vpc_id            = aws_vpc.shopzer-vpc.id
  cidr_block        = var.backend_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "backend subnet ${count.index + 1} created by terraform",
    Description = "backend subnet for shopizer"
  }

  depends_on = [aws_vpc.shopzer-vpc]
}

# Database subnet
resource "aws_subnet" "database_subnet" {

  count             = length(var.database_subnet_cidrs)
  vpc_id            = aws_vpc.shopzer-vpc.id
  cidr_block        = var.database_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "database subnet ${count.index + 1} created by terraform",
    Description = "database subnet for shopizer"
  }

  depends_on = [aws_vpc.shopzer-vpc]
}
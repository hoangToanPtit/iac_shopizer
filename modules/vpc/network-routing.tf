# IGW
resource "aws_internet_gateway" "main-igw" {

  vpc_id = aws_vpc.shopzer-vpc.id
  tags = {
    Name        = "Shopizer IGW"
    Description = "IGW created by terraform"
  }

  depends_on = [aws_vpc.shopzer-vpc]
}

# Route Tables
resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.shopzer-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name        = "Public Route Table"
    Description = "Route table created by terraform"
  }

  depends_on = [aws_vpc.shopzer-vpc, aws_internet_gateway.main-igw]
}

# Route Table Association
resource "aws_route_table_association" "route_public_subnet" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id

  depends_on = [aws_route_table.public_route_table, aws_subnet.public_subnet]
}

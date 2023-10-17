# IGW
resource "aws_internet_gateway" "main-igw" {

  vpc_id = aws_vpc.shopzer-vpc.id
  tags = {
    Name        = "Shopizer IGW"
    Description = "IGW created by terraform"
  }

  depends_on = [aws_vpc.shopzer-vpc]
}

# Network interface
resource "aws_network_interface" "network_interface" {
  count             = length(var.public_subnet_cidrs)
  subnet_id         = aws_subnet.public_subnet[count.index].id
  security_groups   = [aws_security_group.nat_sg.id]
  source_dest_check = false

  tags = {
    Name        = "nat_instance_network_interface ${count.index + 1}"
    Description = "network interface to create nat instance"
  }

  depends_on = [aws_subnet.public_subnet, aws_security_group.nat_sg]
}

# NAT instance
resource "aws_instance" "nat_instance" {
  count         = length(var.public_subnet_cidrs)
  ami           = var.nat_ami
  instance_type = var.instance_type
  key_name      = var.ssh_key_name
  network_interface {
    network_interface_id = aws_network_interface.network_interface[count.index].id
    device_index         = 0
  }

  tags = {
    Name        = "NAT instance"
    Description = ""
  }

  depends_on = [aws_network_interface.network_interface]

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
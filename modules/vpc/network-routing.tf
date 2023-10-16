# IGW
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.shopzer-vpc.id
  tags = {
    Name        = "Shopize IGW"
    Description = "IGW created by terraform"
  }
}

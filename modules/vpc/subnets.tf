data "aws_availability_zones" "available" {
  
}


resource "aws_subnet" "public_subnet" {
    depends_on = [ aws_vpc.shopzer-vpc ]
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.shopzer-vpc.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
      Name = "public subnet ${count.index+1} created by terraform",
      Description = "public subnet for shopizer"
    }
}
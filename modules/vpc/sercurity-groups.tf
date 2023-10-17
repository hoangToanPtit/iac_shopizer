# Variables
variable "tcp_protocol" {
  default = "tcp"

}
# NAT instance SG
resource "aws_security_group" "nat_sg" {
  name        = "NAT_instance_security_group"
  description = "Security Group for NAT insance created by terraform"
  vpc_id      = aws_vpc.shopzer-vpc.id

  ingress = [
    {
      description      = "Ingress CIDR"
      from_port        = 80
      to_port          = 80
      protocol         = var.tcp_protocol
      cidr_blocks      = [var.vpc_cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow access to internet"
      from_port        = 80
      to_port          = 80
      protocol         = var.tcp_protocol
      cidr_blocks      = [var.internet_cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow access to internet"
      from_port        = 443
      to_port          = 443
      protocol         = var.tcp_protocol
      cidr_blocks      = [var.internet_cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "NAT Security Group"

  }
  depends_on = [aws_vpc.shopzer-vpc]
}
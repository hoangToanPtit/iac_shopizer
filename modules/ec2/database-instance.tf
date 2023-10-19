# Bastion SG
resource "aws_security_group" "database-sg" {
  name        = "Database-SG"
  description = "Security Group for Database created by terraform"
  vpc_id      = var.vpc-id

  ingress = [
    {
      description      = "all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [var.internet_cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [var.internet_cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "Database Security Group"

  }
}

resource "aws_network_interface" "database_ni" {
  subnet_id   = var.database_subnet_ids[0]
  private_ips = ["172.20.7.47"]
  security_groups = [aws_security_group.database-sg.id]
  tags = {
    Name        = "db-ni"
    Description = "network interface for database instance"
  }
}

resource "aws_instance" "database-instance" {
  ami                    = var.ubuntu_ami
  instance_type          = "t2.micro"
  key_name               = var.ssh_key_name
  user_data              = "${file("${path.module}/dbinstance.sh")}"

  network_interface {
    network_interface_id = aws_network_interface.database_ni.id
    device_index         = 0
  }

  tags = {
    Name = "Database instance creating by terraform"
  }

  depends_on = [aws_security_group.database-sg, aws_network_interface.database_ni]
}

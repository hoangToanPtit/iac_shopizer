# Bastion SG
resource "aws_security_group" "bastion-sg" {
  name        = "Bastion-Host-SG"
  description = "Security Group for Bastion host created by terraform"
  vpc_id      = var.vpc-id

  ingress = [
    {
      description      = "Allow ssh access from internet"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.internet_cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow access to this VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.vpc_cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow access to internet"
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
    Name = "Bastion host Security Group"

  }
}

resource "aws_instance" "bastion-host" {
  ami                         = var.ubuntu_ami
  instance_type               = "t2.micro"
  key_name                    = var.ssh_key_name
  subnet_id                   = var.public_subnet_ids[0] # first public subnet
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    echo "change default username"
    user=${var.default-name}
    usermod  -l $user ubuntu
    groupmod -n $user ubuntu
    usermod  -d /home/$user -m $user
    if [ -f /etc/sudoers.d/90-cloudimg-ubuntu ]; then
    mv /etc/sudoers.d/90-cloudimg-ubuntu /etc/sudoers.d/90-cloud-init-users
    fi
    perl -pi -e "s/ubuntu/$user/g;" /etc/sudoers.d/90-cloud-init-users
  EOF

  tags = {
    Name = "Bastion host creating by terraform"
  }

  depends_on = [aws_security_group.bastion-sg]
}
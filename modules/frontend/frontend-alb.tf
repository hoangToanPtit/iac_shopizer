# Frontend Load balancer Security group
resource "aws_security_group" "fe-alb-sg" {
  name        = "ALB_frontend_SG"
  description = "Security Group for Frontend load balancer created via Terraform"
  vpc_id      = var.vpc-id

  ingress = [
    {
      description      = "Allow all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [var.internet-cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "ALB_Frontend_SG"
  }
}

# Frontend Load balancer resource
resource "aws_lb" "fe-alb" {
  name                             = "frontend-alb"
  internal                         = false
  load_balancer_type               = "application"                     # application
  security_groups                  = [aws_security_group.fe-alb-sg.id] # choose security groups
  subnets                          = var.public-subnet-ids             # choose public subnet
  enable_cross_zone_load_balancing = true                              # cross zone
  enable_deletion_protection       = false

  tags = {
    Environment = "frontend app"
  }

  depends_on = [aws_security_group.fe-alb-sg]
}

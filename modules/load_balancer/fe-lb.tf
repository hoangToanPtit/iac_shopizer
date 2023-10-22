# Frontend Load balancer resource

# Backend Load balancer resource

resource "aws_security_group" "fe_alb_sg" {
  name        = "ALB_frontend_SG"
  description = "Security Group for Frontend load balancer created via Terraform"
  vpc_id      = var.vpc_id

  ingress = [ # all traffic in
    {
      description      = "allow internet in"
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

  egress = [ # all traffic out to backend subnets
    {
      description      = "Allow access to frontend subnet"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = var.frontend_subnet_cidrs
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "ALB_Backend_SG"

  }
}

resource "aws_lb" "fe_alb" {
  name                             = "frontend-alb"
  internal                         = false
  load_balancer_type               = var.lb_type                       # application
  security_groups                  = [aws_security_group.fe_alb_sg.id] # choose security groups
  subnets                          = var.public_subnet_ids             # choose public subnet
  enable_cross_zone_load_balancing = true                              # cross zone
  enable_deletion_protection       = false

  tags = {
    Environment = "frontend app"
  }
}

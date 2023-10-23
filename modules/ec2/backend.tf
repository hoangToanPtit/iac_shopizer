# Backend SG
resource "aws_security_group" "backend-sg" {
  name        = "Backend-SG"
  description = "Security Group for Backend created by terraform"
  vpc_id      = var.vpc-id

  ingress = [
    {
      description      = "allow all traffic"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [var.alb_be_sg_id]
      self             = false
    },
    {
      description      = "Allow ssh access from Bastion-host"
      from_port        = 2222
      to_port          = 2222
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.bastion-sg.id]
      self             = false
    },
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
      description      = "allow connect to db instance"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.database-sg.id]
      self             = false
    },
    {
      description      = "Allow go to NAT port 80"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = var.public_subnet_cidrs
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow go to NAT port 443"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = var.public_subnet_cidrs
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
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
    Name = "Backend Security Group"

  }

  // depends_on = [aws_security_group.ALB-BE-sg]
}

resource "aws_instance" "backend" {
  count                  = length(var.backend_subnet_ids)
  ami                    = var.ubuntu_ami
  instance_type          = "t2.micro"
  key_name               = var.ssh_key_name
  subnet_id              = var.backend_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.backend-sg.id]
  user_data              = file("${path.module}/beinstance.sh")

  tags = {
    Name = "Backend ${count.index + 1} creating by terraform"
  }

  depends_on = [aws_security_group.backend-sg, aws_instance.database-instance]
}

# create target group
resource "aws_lb_target_group" "backend_tg" {
  name     = "backend-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc-id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

}

# create target attachment
resource "aws_lb_target_group_attachment" "attach-backend" {
  count            = length(aws_instance.backend)
  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id        = aws_instance.backend[count.index].id
  port             = 8080
}

# create listener
resource "aws_lb_listener" "be_listener" {
  load_balancer_arn = var.alb_be_arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}

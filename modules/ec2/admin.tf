# Admin SG
resource "aws_security_group" "admin-sg" {
  name        = "Admin-SG"
  description = "Security Group for Admin created by terraform"
  vpc_id      = var.vpc-id

  ingress = [
    {
      description      = "allow admin alb access"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [var.alb_fe_sg_id]
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
    Name = "Admin Security Group"

  }

}

resource "aws_instance" "admin" {
  count                  = length(var.frontend_subnet_ids)
  ami                    = var.ubuntu_ami
  instance_type          = "t2.micro"
  key_name               = var.ssh_key_name
  subnet_id              = var.frontend_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.admin-sg.id]
  user_data              = <<-EOF
        #!/bin/bash

        echo "Change default username"
        user=shopizer
        usermod  -l $user ubuntu
        groupmod -n $user ubuntu
        usermod  -d /home/$user -m $user
        if [ -f /etc/sudoers.d/90-cloudimg-ubuntu ]; then
        mv /etc/sudoers.d/90-cloudimg-ubuntu /etc/sudoers.d/90-cloud-init-users
        fi
        perl -pi -e "s/ubuntu/$user/g;" /etc/sudoers.d/90-cloud-init-users

        echo "Change default port"
        sudo perl -pi -e 's/^#?Port 22$/Port 2222/' /etc/ssh/sshd_config service
        sudo systemctl restart sshd

        for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

        sudo apt-get update
        sudo apt-get install ca-certificates curl gnupg -y
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo rm -rf /etc/apt/keyrings/docker.gpg
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg

        echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$UBUNTU_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update

        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
        sudo service docker start
        sudo groupadd docker
        sudo usermod -aG docker $USER
        sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
        sudo chmod g+rwx "$HOME/.docker" -R
        newgrp docker
        sudo systemctl enable docker.service
        sudo systemctl enable containerd.service
        sudo service docker restart

        sudo mkdir -p /var/log/nginx

        docker run -d  --restart always \
        -e "APP_BASE_URL=http://${var.alb_be_dns}:8080/api"  \
        -p 82:80 \
        -v /var/log/nginx:/var/log/nginx  \
        ht04/shopizer-admin:1.0.1

        EOF

  tags = {
    Name = "Admin ${count.index + 1} creating by terraform"
  }

  depends_on = [aws_security_group.admin-sg, aws_instance.backend]
}

# create target group
resource "aws_lb_target_group" "admin_tg" {
  name     = "admin-tg"
  port     = 82
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
resource "aws_lb_target_group_attachment" "attach-admin" {
  count            = length(aws_instance.admin)
  target_group_arn = aws_lb_target_group.admin_tg.arn
  target_id        = aws_instance.admin[count.index].id
  port             = 82
}

# create listener
resource "aws_lb_listener" "admin_listener" {
  load_balancer_arn = var.alb_fe_arn
  port              = "82"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin_tg.arn
  }
}

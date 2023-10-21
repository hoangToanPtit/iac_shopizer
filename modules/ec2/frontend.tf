# # Frontend SG
# resource "aws_security_group" "frontend-sg" {
#   name        = "Frontend-SG"
#   description = "Security Group for Frontend created by terraform"
#   vpc_id      = var.vpc-id

#   ingress = [
#     {
#       description      = "Allow ssh access from Bastion-host"
#       from_port        = 2222
#       to_port          = 2222
#       protocol         = "tcp"
#       cidr_blocks      = [module.vpc.public_subnet_cidrs]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     },

#     # {
#     #   description      = "Allow access from ALB-FE"
#     #   from_port        = 80
#     #   to_port          = 80
#     #   protocol         = "http"
#     #   cidr_blocks      = 
#     #   ipv6_cidr_blocks = []
#     #   prefix_list_ids  = []
#     #   security_groups  = []
#     #   self             = false
#     # }
#   ]

#   egress = [
#     {
#       description      = "Allow go to NAT port 80"
#       from_port        = 80
#       to_port          = 80
#       protocol         = "tcp"
#       cidr_blocks      = [module.vpc.public_subnet_cidrs]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     },
#     {
#       description      = "Allow go to NAT port 443"
#       from_port        = 443
#       to_port          = 443
#       protocol         = "tcp"
#       cidr_blocks      = [module.vpc.public_subnet_cidrs]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     }
#   ]

#   tags = {
#     Name = "Frontend Security Group"

#   }

#   // depends_on = [aws_security_group.ALB-FE-sg]
# }

# resource "aws_instance" "frontend" {
#   count                       = length(var.frontend_subnet_ids)
#   ami                         = var.ubuntu_ami
#   instance_type               = "t2.micro"
#   key_name                    = var.ssh_key_name
#   subnet_id                   = element(var.frontend_subnet_ids, count.index)
#   vpc_security_group_ids      = [aws_security_group.frontend-sg.id]
#   associate_public_ip_address = false
#   user_data                   = "${file("${path.module}/feinstance.sh")}"

#   tags = {
#     Name = "Frontend creating by terraform"
#   }

#   depends_on = [aws_security_group.frontend-sg]
# }
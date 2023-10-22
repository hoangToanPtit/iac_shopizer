# Output for load balancer module

output "be_alb_id" {
  value = aws_lb.be_alb.id
}

output "fe_alb_id" {
  value = aws_lb.fe_alb.id
}

output "be_dns_name" {
  value = aws_lb.be_alb.dns_name
}

output "fe_dns_name" {
  value = aws_lb.fe_alb.dns_name
}

output "be_alb_arn" {
  value = aws_lb.be_alb.arn
}

output "fe_alb_arn" {
  value = aws_lb.fe_alb.arn
}

output "be_alb_sg_id" {
  value = aws_security_group.be_alb_sg.id
}

output "fe_alb_sg_id" {
  value = aws_security_group.fe_alb_sg.id
}

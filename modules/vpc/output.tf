output "vpc_id" {
  value = aws_vpc.shopzer-vpc.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnet : subnet.id]
}

output "frontend_subnet_ids" {
  value = [for subnet in aws_subnet.frontend_subnet : subnet.id]
}

output "backend_subnet_ids" {
  value = [for subnet in aws_subnet.backend_subnet : subnet.id]
}

output "database_subnet_ids" {
  value = [for subnet in aws_subnet.database_subnet : subnet.id]
}

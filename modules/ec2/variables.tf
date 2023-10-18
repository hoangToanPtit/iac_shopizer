variable "vpc-id" {
  type = string
}

variable "default_security_group_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "frontend_subnet_ids" {
  type = list(string)
}

variable "backend_subnet_ids" {
  type = list(string)
}

variable "database_subnet_ids" {
  type = list(string)
}

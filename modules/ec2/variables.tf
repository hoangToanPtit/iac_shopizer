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

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "172.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR"
  type        = list(string)
  default     = ["172.20.1.0/24", "172.20.2.0/24"]
}

variable "internet_cidr" {
  description = "cidr block for internet"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_key_name" {
  type    = string
  default = "keypair-l1"
}

variable "frontend_subnet_cidrs" {
  description = "Subnet for frontend"
  type        = list(string)
  default     = ["172.20.3.0/24", "172.20.4.0/24"]

}
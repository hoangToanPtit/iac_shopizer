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

variable "nat_ami" {
  description = "ami to create nat instance"
  type        = string
  default     = "ami-036fb5fe12bc53979"
}

variable "internet_cidr" {
  description = "cidr block for internet"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_key_name" {
  type = string
}

variable "frontend_subnet_cidrs" {
  description = "Subnet for frontend"
  type        = list(string)
  default     = ["172.20.3.0/24", "172.20.4.0/24"]

}

variable "backend_subnet_cidrs" {
  description = "Subnet for frontend"
  type        = list(string)
  default     = ["172.20.5.0/24", "172.20.6.0/24"]

}

variable "database_subnet_cidrs" {
  description = "Subnet for frontend"
  type        = list(string)
  default     = ["172.20.7.0/24"]
}

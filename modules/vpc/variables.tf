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
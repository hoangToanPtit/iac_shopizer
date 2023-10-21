# Input variables for load balancer module
variable "vpc_id" {
  type    = string
  default = "172.20.0.0/16"
}

variable "lb_type" {
  type    = string
  default = "application"
}

variable "backend_subnet_cidrs" {
  type    = list(string)
  default = ["172.20.5.0/24", "172.20.6.0/24"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["172.20.1.0/24", "172.20.2.0/24"]
}

variable "public_subnet_ids" {
  type = list(string)
}

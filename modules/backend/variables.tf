variable "vpc-id" {
  type = string
}

variable "public-subnet-ids" {
  type = list(string)
}

variable "backend-subnet-ids" {
  type = list(string)
}

variable "default-name" {
  type    = string
  default = "shopizer"
}

variable "internet-cidr" {
  description = "cidr block for internet"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh-key-name" {
  type    = string
  default = "keypair-l2"
}

variable "ubuntu-ami" {
  type = string
}

variable "default-ssh-port" {
  type    = string
  default = "2222"
}
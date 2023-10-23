variable "vpc-id" {
  type = string
}

variable "internet-cidr" {
  description = "cidr block for internet"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ubuntu-ami" {
  type    = string
  default = "ami-0df7a207adb9748c7"
}

variable "ssh-key-name" {
  type    = string
  default = "keypair-l2"
}

variable "private-ip" {
  type    = string
  default = "172.20.7.47"
}
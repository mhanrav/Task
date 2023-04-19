variable "cidr_block" {
  type = map(string)
  description = "CIDR Block for vpc"
}

variable "public_subnets" {
  type = map(list(string))
  description = "List of public subnet cidrs"
}

variable "private_subnets" {
  type = map(list(string))
  description = "List of private subnet cidrs"
}

variable "DEFAULT_TAGS" {
  type = map(any)
  description = "Default Tags for all resources"
}

variable "STAGE" {
  type = string
  default = "Environment"
  description = "Stage for deployment"
}

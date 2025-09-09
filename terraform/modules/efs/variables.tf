
variable "name" {
  type = string
  default = "monitoring-efs"
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type        = map(string)
  description = "Map of subnet_ids keyed by AZ or name"
}

variable "security_groups" {
  type = list(string)
}

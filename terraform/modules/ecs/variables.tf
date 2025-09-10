variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "task_execution_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "prometheus_image" {
  type = string
}

variable "grafana_image" {
  type = string
}

variable "alertmanager_image" {
  type = string
}

variable "efs_id" {
  type = string
}

variable "prometheus_ap_id" {
  type = string
}

variable "grafana_ap_id" {
  type = string
}

variable "alertmanager_ap_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "alb_security_group" {
  type = list(string)
}

# ALB Variables
variable "tg_prometheus_arn" {
  type = string
}

variable "tg_grafana_arn" {
  type = string
}

variable "tg_alertmanager_arn" {
  type = string
}

variable "listener_arn" {
  type = string
}
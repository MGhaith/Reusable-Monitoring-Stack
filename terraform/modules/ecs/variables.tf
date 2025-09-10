variable "cluster_name" {
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

variable "security_groups" {
  type = list(string)
}

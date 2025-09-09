
output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "prometheus_ap_id" {
  value = aws_efs_access_point.prometheus.id
}

output "grafana_ap_id" {
  value = aws_efs_access_point.grafana.id
}

output "alertmanager_ap_id" {
  value = aws_efs_access_point.alertmanager.id
}
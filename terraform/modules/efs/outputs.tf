
output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "monitoring_ap_id" {
  value = aws_efs_access_point.monitoring.id
}
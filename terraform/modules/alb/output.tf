output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "tg_prometheus_arn" {
  value = aws_lb_target_group.prometheus.arn
}

output "tg_grafana_arn" {
  value = aws_lb_target_group.grafana.arn
}

output "tg_alertmanager_arn" {
  value = aws_lb_target_group.alertmanager.arn
}

output "listener_arn" {
  value = aws_lb_listener.http.arn
}
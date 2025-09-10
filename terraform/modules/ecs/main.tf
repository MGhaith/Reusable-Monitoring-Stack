############################################################
# ECS MODULE
############################################################

# ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.cluster_name}"
  }
}

############################################################
# TASK DEFINITIONS
############################################################

data "aws_region" "current" {}

# Prometheus Task Definition
resource "aws_ecs_task_definition" "prometheus" {
  family                   = "prometheus-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.task_execution_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "prometheus"
      image     = "${var.prometheus_image}"
      essential = true
      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "prometheus-data"
          containerPath = "/prometheus"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/prometheus"
          awslogs-region        = data.aws_region.current.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  volume {
    name = "prometheus-data"
    efs_volume_configuration {
      file_system_id          = var.efs_id
      authorization_config {
        access_point_id = var.prometheus_ap_id
        iam             = "ENABLED"
      }
      transit_encryption = "ENABLED"
    }
  }
}

# Grafana Task Definition
resource "aws_ecs_task_definition" "grafana" {
  family                   = "grafana-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.task_execution_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "grafana"
      image     = "${var.grafana_image}"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "grafana-data"
          containerPath = "/var/lib/grafana"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/grafana"
          awslogs-region        = data.aws_region.current.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  volume {
    name = "grafana-data"
    efs_volume_configuration {
      file_system_id          = var.efs_id
      authorization_config {
        access_point_id = var.grafana_ap_id
        iam             = "ENABLED"
      }
      transit_encryption = "ENABLED"
    }
  }
}

# Alertmanager Task Definition
resource "aws_ecs_task_definition" "alertmanager" {
  family                   = "alertmanager-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.task_execution_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "alertmanager"
      image     = "${var.alertmanager_image}"
      essential = true
      portMappings = [
        {
          containerPort = 9093
          hostPort      = 9093
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "alertmanager-data"
          containerPath = "/alertmanager"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/alertmanager"
          awslogs-region        = data.aws_region.current.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  volume {
    name = "alertmanager-data"
    efs_volume_configuration {
      file_system_id          = var.efs_id
      authorization_config {
        access_point_id = var.alertmanager_ap_id
        iam             = "ENABLED"
      }
      transit_encryption = "ENABLED"
    }
  }
}

# Log group for Prometheus
resource "aws_cloudwatch_log_group" "prometheus" {
  name              = "/ecs/prometheus"
  retention_in_days = 7
}

# Log group for Grafana
resource "aws_cloudwatch_log_group" "grafana" {
  name              = "/ecs/grafana"
  retention_in_days = 7
}

# Log group for Alertmanager
resource "aws_cloudwatch_log_group" "alertmanager" {
  name              = "/ecs/alertmanager"
  retention_in_days = 7
}

############################################################
# SERVICES
############################################################

resource "aws_ecs_service" "prometheus" {
  name            = "prometheus-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.prometheus.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = var.security_groups
    assign_public_ip = false
  }
}

resource "aws_ecs_service" "grafana" {
  name            = "grafana-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.grafana.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = var.security_groups
    assign_public_ip = false
  }
}

resource "aws_ecs_service" "alertmanager" {
  name            = "alertmanager-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.alertmanager.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = var.security_groups
    assign_public_ip = false
  }
}
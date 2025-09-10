############################################################
# 1. VPC Module
############################################################
module "vpc" {
  source = "./modules/vpc"

  name   = "monitoring-vpc"
  cidr   = "10.0.0.0/16"
  azs    = ["eu-central-1a", "eu-central-1b"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
}

############################################################
# 2. IAM Roles
############################################################
module "iam" {
  source = "./modules/iam"
}

############################################################
# 3. EFS for Persistent Storage
############################################################
module "efs" {
  source = "./modules/efs"
  name = "monitoring"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets
  security_groups = [module.vpc.default_sg_id]
}

############################################################
# 4. ECS Cluster + Services
############################################################
module "ecs" {
  source = "./modules/ecs"

  cluster_name        = "monitoring-cluster"
  vpc_id              = module.vpc.vpc_id
  task_execution_arn  = module.iam.ecs_task_execution_role_arn
  task_role_arn       = module.iam.ecs_task_role_arn
  prometheus_image    = "prom/prometheus:v2.53.5"
  grafana_image       = "grafana/grafana:12.1.1"
  alertmanager_image  = "prom/alertmanager:v0.28.1"
  efs_id              = module.efs.efs_id
  prometheus_ap_id    = module.efs.prometheus_ap_id
  grafana_ap_id       = module.efs.grafana_ap_id
  alertmanager_ap_id  = module.efs.alertmanager_ap_id
  private_subnets     = module.vpc.private_subnets_list
  alb_security_group  = [module.alb.alb_sg_id]

  tg_prometheus_arn = module.alb.tg_prometheus_arn
  tg_grafana_arn = module.alb.tg_grafana_arn
  tg_alertmanager_arn = module.alb.tg_alertmanager_arn
  listener_arn = module.alb.listener_arn
}

############################################################
# 5. Application Load Balancer (ALB)
############################################################
module "alb" {
  source = "./modules/alb"

  project_name    = "reusable-monitoring-stack"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets_list
}
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

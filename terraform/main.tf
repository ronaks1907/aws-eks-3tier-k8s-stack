module "vpc" {
  source               = "./modules/vpc"
  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  app_subnet_1_cidr    = var.app_subnet_1_cidr
  app_subnet_2_cidr    = var.app_subnet_2_cidr
  db_subnet_1_cidr     = var.db_subnet_1_cidr
  db_subnet_2_cidr     = var.db_subnet_2_cidr
}

module "rds" {
  source         = "./modules/rds"
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  db_subnet_1_id = module.vpc.db_subnet_1_id
  db_subnet_2_id = module.vpc.db_subnet_2_id
  depends_on     = [module.vpc]
}

module "eks" {
  source          = "./modules/eks"
  region          = var.region
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  app_subnet_1_id = module.vpc.app_subnet_1_id
  app_subnet_2_id = module.vpc.app_subnet_2_id
  depends_on      = [module.vpc]
}

module "add-ons" {
  source       = "./modules/add-ons"
  cluster_name = module.eks.cluster_name
  depends_on   = [module.eks]
}

module "oidc" {
  source            = "./modules/oidc"
  environment       = var.environment
  cluster_name      = module.eks.cluster_name
  oidc_provider_url = module.eks.oidc_provider_url
  depends_on        = [module.eks]
}

module "alb" {
  source            = "./modules/alb"
  region            = var.region
  environment       = var.environment
  oidc_provider_url = module.eks.oidc_provider_url
  vpc_id            = module.vpc.vpc_id
  app_subnet_1_id   = module.vpc.app_subnet_1_id
  app_subnet_2_id   = module.vpc.app_subnet_2_id
  cluster_name      = module.eks.cluster_name
  depends_on        = [module.eks, module.oidc]
}
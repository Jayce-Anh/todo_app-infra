################################ MAIN #################################

#---------VPC---------#
module "vpc" {
  source     = "../../modules/vpc"
  project    = local.project
  tags       = local.tags
  cidr_block = var.cidr_block
  subnet_az  = var.subnet_az
}

#---------ACM---------#
module "acm" {
  source  = "../../modules/acm"
  project = local.project
  tags    = local.tags
  domain  = var.domain
  region  = local.project.region
}

#---------PARAMETER STORE---------#
module "parameter_store" {
  source          = "../../modules/parameter_store"
  project         = local.project
  tags            = local.tags
  source_services = var.source_services
}

#---------EXTERNAL LB----------#
module "alb" {
  source                 = "../../modules/alb/external"
  project                = local.project
  tags                   = local.tags
  lb_name                = var.lb_name
  vpc_id                 = module.vpc.vpc_id
  dns_cert_arn           = module.acm.cert_arn
  subnet_ids             = module.vpc.public_subnet_ids
  source_ingress_sg_cidr = var.source_ingress_sg_cidr
  enable_https_listener  = var.enable_https_listener
  target_groups = {
    be = {
      name              = var.target_groups.be.name
      service_port      = var.target_groups.be.service_port
      health_check_path = var.target_groups.be.health_check_path
      priority          = var.target_groups.be.priority
      host_header       = var.target_groups.be.host_header
      ec2_id            = module.ec2_instance.ec2_id
    }
    fe = {
      name              = var.target_groups.fe.name
      service_port      = var.target_groups.fe.service_port
      health_check_path = var.target_groups.fe.health_check_path
      priority          = var.target_groups.fe.priority
      host_header       = var.target_groups.fe.host_header
      ec2_id            = module.ec2_instance.ec2_id
    }
  }
}


#---------APPLICATION SERVER---------#
module "ec2_instance" {
  source                     = "../../modules/ec2"
  project                    = local.project
  tags                       = local.tags
  vpc_id                     = module.vpc.vpc_id
  enabled_eip                = var.enabled_eip
  instance_type              = var.instance_type
  instance_name              = var.instance_name
  iops                       = var.iops
  volume_size                = var.volume_size
  path_user_data             = var.path_user_data
  key_name                   = var.key_name
  subnet_id                  = module.vpc.public_subnet_ids[0]

  sg_ingress = merge(var.sg_ingress, {
    rule2 = merge(var.sg_ingress["rule2"], {
      source_security_group_id = module.alb.lb_sg_id
    })
  })
  
  sg_egress = var.sg_egress
}


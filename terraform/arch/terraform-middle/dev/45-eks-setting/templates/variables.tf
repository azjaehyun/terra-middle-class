variable "context" {
  type = object({
    aws_credentials_file    = string # describe a path to locate a credentials from access aws cli
    aws_profile             = string # describe a specifc profile to access a aws cli
    aws_region              = string # describe default region to create a resource from aws
    region_alias            = string # region alias or AWS
    project                 = string # project name is usally account's project name or platform name
    environment             = string # Runtime Environment such as develop, stage, production
    env_alias               = string # Runtime Environment such as develop, stage, production
    owner                   = string # project owner
    team                    = string # Team name of Devops Transformation
    generator_date          = string # generator_date
    domain                  = string # public domain name (ex, tools.customer.co.kr)
    pri_domain              = string # private domain name (ex: toolchain)
    #access_key              = string
    #secret_key              = string
  })
}

variable "acm_arm_id" {
  description = "certicate manager arn ex) arn:aws:acm:ap-northeast-2:767404772322:certificate/c03ede54-1ac6-4fb1-bdec-d69cac3f6c11
  type        = string
}

locals {
  name_prefix               = format("%s-%s%s", var.context.project, var.context.region_alias, var.context.env_alias)
  tags = {
    Project     = var.context.project
    Environment = var.context.environment
    Team        = var.context.team
    Owner       = var.context.owner
  }
}

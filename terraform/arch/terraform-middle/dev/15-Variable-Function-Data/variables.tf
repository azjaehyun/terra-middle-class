variable "context" {
  type = object({
    aws_credentials_file = string # describe a path to locate a credentials from access aws cli
    aws_profile          = string # describe a specifc profile to access a aws cli
    aws_region           = string # describe default region to create a resource from aws
    region_alias         = string # region alias or AWS
    project              = string # project name is usally account's project name or platform name
    environment          = string # Runtime Environment such as develop, stage, production
    env_alias            = string # Runtime Environment such as develop, stage, production
    owner                = string # project owner
    team                 = string # Team name of Devops Transformation
    generator_date       = string # generator_date
    domain               = string # public domain name (ex, tools.customer.co.kr)
    pri_domain           = string # private domain name (ex: toolchain)
    #access_key              = string
    #secret_key              = string
  })
}

locals {
  name_prefix = format("%s-%s%s", var.context.project, var.context.region_alias, var.context.env_alias)
  tags = {
    Project     = var.context.project
    Environment = var.context.environment
    Team        = var.context.team
    Owner       = var.context.owner
  }
}


variable "regions" {
  type = map(any)
  default = {
    "east" = {
      "region" = "us-east-1",
    },
    "west" = {
      "region" = "eu-west-1",
    },
    "south" = {
      "region" = "ap-south-1",
    },
  }
}

variable "stringVal" {
  type    = string
  default = "stringVal"
}

variable "stringValNull" {
  type    = string
  default = ""
}

# variable validation
variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^ami-", var.image_id))
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
  sensitive = true
}

variable "shell_test" {
  type = string
  #sensitive = true 
  default = "shell_test"
}

# ec2 connect
## resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
## data source : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/key_pair
module "aws_key_pair" {
  source = "../../../../modules/aws/keypair"
  keypair_name   = "${var.keypair_name}"
  tag_name = merge(local.tags, {Name = format("%s-key", local.name_prefix)})
}

# vpc setting
## resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
## data source : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
module "aws_vpc" {
  source     = "../../../../modules/aws/vpc"
  cidr_block = "${var.vpc_cidr}.0.0/16"
  tag_name = merge(local.tags, {Name = format("%s-vpc", local.name_prefix)})
}

# https://www.devc4sh.com/11 vpc internet gateway enable 참조
# internet gateway & NAT & subnet Network
# resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# data source : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/internet_gateway
# 응용 리소스 : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway_attachment
module "aws_vpc_network" {
  source    = "../../../../modules/aws/network/igw_nat_subnet"
  internet_gateway_enabled = true
  vpc_id    = module.aws_vpc.vpc_id
  subnet_id = module.aws_public_subnet_a.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-igw-nat-sunet", local.name_prefix)})
}

module "aws_public_subnet_a" { 
  source     = "../../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.11.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = true
  availability_zone = "${var.context.aws_region}a"
  tag_name = merge(local.tags, {Name = format("%s-subnet-public-a", local.name_prefix)})
}

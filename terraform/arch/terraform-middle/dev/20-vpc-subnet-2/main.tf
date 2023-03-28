
# ec2 connect
## resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
## data source : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/key_pair
module "aws_key_pair" {
  source = "../../../../modules/aws/keypair"
  keypair_name   = var.keypair_name
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
  subnet_id = module.aws_public_subnet_web_a.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-igw-nat-sunet", local.name_prefix)})
}



#
module "aws_public_subnet_web_a" { 
  source     = "../../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.11.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = true
  availability_zone = "${var.context.aws_region}a"
  tag_name = merge(local.tags, {Name = format("%s-subnet-public-a", local.name_prefix)})
}


# public subnet setting - [ availability_zone_c ] - 예비 
module "aws_public_subnet_web_c" {
  source     = "../../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.12.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = true
  availability_zone = "${var.context.aws_region}c"
  tag_name = merge(local.tags, {Name = format("%s-subnet-public-c", local.name_prefix)})
}


# private subnet setting - [ availability_zone_a ] - web1
module "aws_private_subnet_web_a" {
  source     = "../../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.1.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = false
  availability_zone = "${var.context.aws_region}a"
  tag_name = merge(local.tags, {Name = format("%s-subnet-private-web-a", local.name_prefix)})
}

# private subnet setting - [ availability_zone_c ] - web2
module "aws_private_subnet_web_c" {
  source     = "../../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.2.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = false
  availability_zone = "${var.context.aws_region}c"
  tag_name = merge(local.tags, {Name = format("%s-subnet-private-web-c", local.name_prefix)})
}

# public route setting - [ internetgateway route table ]
# resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# data source : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table
resource "aws_route_table" "public-route" {
  vpc_id = module.aws_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.aws_vpc_network.igw_id
  }
  tags = merge(local.tags, {Name = format("%s-public-route", local.name_prefix)})
}

# resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "to-public-a" {
  subnet_id      = module.aws_public_subnet_web_a.subnet_id
  route_table_id = aws_route_table.public-route.id
}


resource "aws_route_table_association" "to-public-c" {
  subnet_id      = module.aws_public_subnet_web_c.subnet_id
  route_table_id = aws_route_table.public-route.id
}


# private route setting
resource "aws_route_table" "private-route" {
  vpc_id = module.aws_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.aws_vpc_network.nat_gateway_id
  }
  tags = merge(local.tags, {Name = format("%s-private-route", local.name_prefix)})
}

resource "aws_route_table_association" "to-private-web-a" {
  subnet_id      = module.aws_private_subnet_web_a.subnet_id
  route_table_id = aws_route_table.private-route.id
}

resource "aws_route_table_association" "to-private-web-c" {
  subnet_id      = module.aws_private_subnet_web_c.subnet_id
  route_table_id = aws_route_table.private-route.id
}


# resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# data source : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group
module "aws_sg_default" {
  source = "../../../../modules/aws/security"
  vpc_id = module.aws_vpc.vpc_id
  name =  format("%s-sg-ssh-default", local.name_prefix)
  tag_name = merge(local.tags, {Name = format("%s-sg-default", local.name_prefix)})
}

# open port 22 - 80
module "aws_sg_web" {
  source = "../../../../modules/aws/security/web"
  vpc_id = module.aws_vpc.vpc_id
  name =  format("%s-sg-22-3000", local.name_prefix)
  tag_name = merge(local.tags, {Name = format("%s-sg-web", local.name_prefix)})
}

# open port 22 - 8080
module "aws_sg_was" {
  source = "../../../../modules/aws/security/was"
  vpc_id = module.aws_vpc.vpc_id
  name =  format("%s-sg-22-8080", local.name_prefix)
  tag_name = merge(local.tags, {Name = format("%s-sg-was", local.name_prefix)})
}


module "public-web-a" {
  source        = "../../../../modules/aws/ec2/ec2_public"
  ami_id        = var.ami_id
  sg_groups     = [module.aws_sg_web.sg_id]
  key_name      = module.aws_key_pair.key_name
  subnet_id     = module.aws_private_subnet_web_a.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-ec2-private-web-a", local.name_prefix)})
}

module "public-web-c" {
  source        = "../../../../modules/aws/ec2/ec2_public"
  ami_id        =  var.ami_id
  sg_groups     = [module.aws_sg_web.sg_id]
  key_name      = module.aws_key_pair.key_name
  subnet_id     = module.aws_private_subnet_web_c.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-ec2-private-web-c", local.name_prefix)})
}

## alb area 
# ALB
module "aws-lb-web-alb" {
    source             = "../../../../modules/aws/loadbalancer"
    lb_name = format("%s-web-alb", local.name_prefix)
    lb_internal           = false
    lb_type = "application"
    security_groups    = [module.aws_sg_web.sg_id]
    subnets            = [module.aws_public_subnet_web_a.subnet_id, module.aws_public_subnet_web_c.subnet_id]
    tag_name = merge(local.tags, {Name = format("%s-web-alb", local.name_prefix)})
    
    #target group setting
    lb_target_group_name = format("%s-web-alb-tg", local.name_prefix)
    vpc_id = module.aws_vpc.vpc_id
    lb_protocol = "HTTP"
    tg_tag_name = merge(local.tags, {Name = format("%s-web-tg", local.name_prefix)})

    #lb_attachment setting - ec2 연결 
    nlb_listeners_ids = [ module.public-web-a.ami-ec2_id , module.public-web-c.ami-ec2_id ]
    target_port = 80
    depends_on = [module.public-web-a,module.public-web-c]
}


resource "aws_lb_target_group_attachment" "web-alb-tg-att-web1" {
    target_group_arn = module.aws-lb-web-alb.lb-tg-arn
    target_id = module.public-web-a.ami-ec2_id
    port = 80
}

resource "aws_lb_target_group_attachment" "web-alb-tg-att-web2" {
    target_group_arn = module.aws-lb-web-alb.lb-tg-arn
    target_id = module.public-web-c.ami-ec2_id
    port = 80
}
data "aws_acm_certificate" "this" {
  domain = var.context.domain
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_prefix}-vpc"]
  }
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.this.id
  filter {
    name   = "tag:kubernetes.io/cluster/${local.cluster_name}"
    values = ["shared"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.this.id
  filter {
    name   = "tag:kubernetes.io/role/elb"
    values = ["1"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.this.id
  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }
}

data "aws_subnet_ids" "workers" {
  vpc_id = data.aws_vpc.this.id

  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }

  filter {
    name   = "tag:Project"
    values = [ var.context.project ]
  }

}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

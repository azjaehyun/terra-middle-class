resource "aws_subnet" "subnet-template" {
  vpc_id = var.vpc_id
  tags = var.tag_name
  map_public_ip_on_launch = var.is_public
  cidr_block              = var.cidr_block
  availability_zone = var.availability_zone
}
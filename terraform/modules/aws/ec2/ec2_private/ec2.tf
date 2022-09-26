resource "aws_instance" "instance-template" {
  #ami                    = data.aws_ami.ubuntu.id
  ami = "ami-005788ec768e895a0" 
  instance_type          = var.instance_type
  vpc_security_group_ids = var.sg_groups
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  tags = var.tag_name
}

output "public_ip" {
  value = aws_instance.instance-template.public_ip
}

output "private_ip" {
  value = aws_instance.instance-template.private_ip
}

output "igw_id" {
  #value = ["${aws_internet_gateway.igw-template.*.id}"]
  value = aws_internet_gateway.igw-template.id
}


output "ssh_private_key_pem" {
  value = module.aws_key_pair.ssh_private_key_pem
  sensitive = true
}

output "ssh_public_key_pem" {
  value = module.aws_key_pair.ssh_public_key_pem
  sensitive = true
}

output "springboot_public_ip" {
  value = module.aws_ec2_public_docker_springboot_ec2.public_ip
}

output "react_public_ip" {
  value = module.aws_ec2_public_docker_react_ec2.public_ip
}

output "ssh_private_key_pem" {
  value = module.aws_key_pair.ssh_private_key_pem
  sensitive = true
}

output "ssh_public_key_pem" {
  value = module.aws_key_pair.ssh_public_key_pem
  sensitive = true
}

output "private-ec2-id"{
   value = module.private-web-a.ami-ec2_id
}

output "private-ec2-ip"{
   value = module.private-web-a.ami-private_ip
}

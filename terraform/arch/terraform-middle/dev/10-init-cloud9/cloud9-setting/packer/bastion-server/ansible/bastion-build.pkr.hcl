packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "terraform-middle-bastion"
  instance_type = "t2.micro"
  region        = "ap-northeast-2"
  subnet_filter {
    filters = {
         "tag:Name": "terraformPrac-an2p-subnet-public-a*"
    }
  }
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  ssh_keypair_name = "terraformTest-key"
  ssh_private_key_file = "~/.ssh/terraform-prac.pem"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]


  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "sudo apt-get install -y  software-properties-common",
      "sudo apt-add-repository ppa:ansible/ansible",
      "sudo apt-get update ",
      "sudo apt-get install -y ansible"
    ]
  }

  provisioner "ansible-local" {
    playbook_file   = "./playbook-bastion.yml"
  }

}

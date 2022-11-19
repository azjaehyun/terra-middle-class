# Gitlab EKS Node
 EKS 워커 노드를 위한 AMI 기본(Golden)이미지를 빌드 합니다


Variables
----------
[role variables](../../ansible/roles/aws-eks/README.md)


Build
----------
- 먼저 환경 변수를 확인 하세요.
```shell
echo "AWS_PROFILE: $AWS_PROFILE, AWS_REGION: $AWS_REGION, AWS_OWNER: $AWS_OWNER"
```
- ubuntu 기본 이미지 기반으로 Gitlab EKS Node 이미지를 빌드 합니다.
```shell

# project 체크아웃
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook

cat > ./ansible/playbook-eks-node.yml << EOF
---
- name: Building AWS Golden AMI Image
  hosts: all
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: lsof
    - role: htop
    - role: aws-cli
    - role: aws-ssm-agent
    - role: os-hardening
    - role: ssh-hardening
    - role: aws-eks
      kubernetes_version: "{{ kubernetes_version | default('1.19.6') }}"
      kubernetes_build_date: "{{ kubernetes_build_date | default('2021-01-05') }}"
      cni_plugin_version: "{{ cni_plugin_version | default('v0.8.7') }}"
      dockerce_version: "5:20.10.5~3-0~ubuntu-bionic"
      dockercecli_version: "5:20.10.5~3-0~ubuntu-bionic"
      containerdio_version: "1.4.4-1"      
      disk_part: true
      disk_part_target: "default"
    - role: cleansing
EOF

packer validate ./packer/eks-node/ubuntu/build.json

packer build ./packer/eks-node/ubuntu/build.json
```

Appendix
----------
- [Packer build](ubuntu/build.json) 
- [Ansible Playbook](../../ansible/roles/aws-eks/README.md) 


Constraints
----------
None
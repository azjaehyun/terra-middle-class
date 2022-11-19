# nexus3 EKS Node
nexus3 EKS 워커 노드를 위한 AMI 이미지를  빌드 합니다

Build
----------
- 먼저 환경 변수를 확인 하세요.
```shell
echo "AWS_PROFILE: $AWS_PROFILE, AWS_REGION: $AWS_REGION, AWS_OWNER: $AWS_OWNER"
```

```shell

# project 체크아웃
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook

cat > ./ansible/playbook-eks-nexus.yml <<EOF
---
- name: Building Nexus EKS Node Image
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
    - role: aws-eks
      disk_part: false
    - role: docker-nexus
      keycloak_plugin:
        enable: true
        version: 0.6.0-SNAPSHOT        
    - role: cleansing
EOF

packer validate ./packer/eks-nexus/ubuntu/build.json

packer build ./packer/eks-nexus/ubuntu/build.json
```


Appendix
----------
- [Packer build](ubuntu/build.json) 참고
- [Playbook](../../ansible/roles/docker-nexus/README.md) 참고


Constraints
----------
None
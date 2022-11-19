#Docker-DX-Spinnaker

Ubuntu AMI 기본 이미지 기반으로  Spinnaker EKS Node 이미지를 빌드 합니다.


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

cat > ./ansible/playbook-eks-spinnaker.yml <<EOF
---
- name: Building AWS EKS Golden AMI Image
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
    - role: docker-redis
    - role: docker-spinnaker      
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin123$
        project: tools/spinnaker
        upload: false       
    - role: cleansing
EOF

packer validate ./packer/eks-spinnaker/ubuntu/build.json

packer build ./packer/eks-spinnaker/ubuntu/build.json
```


Appendix
----------
- [Packer build](ubuntu/build.json) 참고
- [Playbook](../../ansible/roles/docker-spinnaker/README.md) 참고

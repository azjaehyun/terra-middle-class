# Java EKS Node
Java EKS 워커 노드를 위한 AMI 이미지를  빌드 합니다

Build
----------
- 먼저 환경 변수를 확인 하세요.
```shell
echo "AWS_PROFILE: $AWS_PROFILE, AWS_REGION: $AWS_REGION, AWS_OWNER: $AWS_OWNER"
```
- ubuntu 기본 이미지 기반으로 Java EKS Node 이미지를 빌드 합니다.
```shell

# project 체크아웃
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook

cat > ./ansible/playbook-eks-java.yml << EOF
---
- name: Building Java EKS Node Image
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
    - role: docker-java
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin123$
        project: tools
        upload: false
      image:
        name: openjdk11
        tag: ubuntu-slim
    - role: docker-fluentbit
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin
        project: tools
        upload: false
      image:
        name: fluent-bit
        tag: 1.7
    - role: cleansing
EOF

packer validate ./packer/eks-java/ubuntu/build.json

packer build ./packer/eks-java/ubuntu/build.json
```


Appendix
----------
- [Packer build](ubuntu/build.json) 참고
- [Playbook](../../ansible/roles/docker-java/README.md) 참고


제약사항
----------
None
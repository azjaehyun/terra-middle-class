# Sonarqube EKS Node
Sonarqube EKS 워커 노드를 위한 AMI 이미지를  빌드 합니다

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

cat > ./ansible/playbook-eks-sonarqube.yml << EOF
---
- name: Building Sonarqube EKS Golden AMI Image
  hosts: all
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: aws-cli
    - role: sudo
    - role: java
      java_packages:
      - openjdk-11-jdk
    - role: lsof
    - role: htop
    - role: aws-eks
      disk_part: true
      disk_part_target: default
    - role: docker-sonarqube
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin123$
        project: tools
        upload: false
      image:
        name: sonarqube
        tag: 8.9.1-community
      oidc_plugin:
        enable: true
        version: "2.0.0"        
    - role: cleansing
EOF

packer validate ./packer/eks-sonarqube/ubuntu/build.json

packer build ./packer/eks-sonarqube/ubuntu/build.json
```

Appendix
----------

- [Packer build](ubuntu/build.json) 참고
- [Docker Run]


Constraints
----------
None
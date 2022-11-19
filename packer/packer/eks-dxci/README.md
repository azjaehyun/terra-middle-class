# DxCI EKS Node
DX Toolchain 중 CI(Continuous Integration) 서비스를 위한 EKS 워커 노드 AMI 이미지를 빌드 합니다


Toolchain
----------
- gitlab
- gitlab-runner
- nexus
- sonarqube


Build
----------
- 먼저 환경 변수를 확인 하세요.
```shell
echo "AWS_PROFILE: $AWS_PROFILE, AWS_REGION: $AWS_REGION, AWS_OWNER: $AWS_OWNER"
```
- ubuntu 기본 이미지 기반으로 Toolchain 의 CI Node 이미지를 빌드 합니다.
```shell

# project 체크아웃
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook

cat > ./ansible/playbook-eks-dxci.yml <<EOF
- name: Building EKS DxCI AMI Image
  hosts: all
  become: true
  vars_files:
    - group_vars/defaults.yml
  roles:
    - role: sudo
    - role: lsof
    - role: htop
    - role: aws-cli
    - role: aws-ssm-agent
    - role: java
    - role: aws-eks
      disk_part: true
      disk_part_target: "default"
      kubernetes_version: '1.19.6'
      kubernetes_build_date: '2021-01-05'
      cni_plugin_version: 'v0.8.7'
    - role: docker-gitlab
    - role: docker-gitlab-runner
    - role: docker-nexus
      keycloak_plugin:
        enable: true
        version: 0.6.0-SNAPSHOT
    - role: docker-sonarqube
      oidc_plugin:
        enable: true
        version: "2.0.0"
    - role: cleansing
EOF

packer validate ./packer/eks-dxci/ubuntu/build.json

packer build ./packer/eks-dxci/ubuntu/build.json
```


Appendix
----------
- [Packer build](ubuntu/build.json)

**Playbook 참고**
- [aws-eks](../../ansible/roles/aws-eks/README.md)
- [docker-gitlab](../../ansible/roles/docker-gitlab/README.md)
- [docker-gitlab-runner](../../ansible/roles/docker-gitlab-runner/README.md)
- [docker-nexus](../../ansible/roles/docker-nexus/README.md)
- [docker-sonarqube](../../ansible/roles/docker-sonarqube/README.md)


Constraints
----------
None
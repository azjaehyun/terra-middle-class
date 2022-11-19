# DxCD EKS Node
DX Toolchain 중 CD(Continuous Delivery) 서비스를 위한 EKS 워커 노드 AMI 이미지를 빌드 합니다


Toolchain
----------
- redis
- harbor
- spinnaker  
- grafana


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

cat > ./ansible/playbook-eks-dxcd.yml <<EOF
- name: Building EKS DxCD AMI Image
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
    - role: aws-eks
      disk_part: true
      disk_part_target: "default"
      kubernetes_version: '1.19.6'
      kubernetes_build_date: '2021-01-05'
      cni_plugin_version: 'v0.8.7'
    - role: docker-redis
    - role: docker-harbor
      image:
        tag: v2.2.2
    - role: docker-spinnaker
    - role: docker-grafana
    - role: cleansing
EOF

packer validate ./packer/eks-dxcd/ubuntu/build.json

packer build ./packer/eks-dxcd/ubuntu/build.json
```


Appendix
----------
- [Packer build](ubuntu/build.json)

**Playbook 참고**
- [aws-eks](../../ansible/roles/aws-eks/README.md)
- [docker-redis](../../ansible/roles/docker-redis/README.md)
- [docker-harbor](../../ansible/roles/docker-harbor/README.md)
- [docker-spinnaker](../../ansible/roles/docker-spinnaker/README.md)
- [docker-grafana](../../ansible/roles/docker-grafana/README.md)


Constraints
----------
None
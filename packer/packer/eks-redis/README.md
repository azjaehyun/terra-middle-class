# Redis EKS Node
Redis EKS 워커 노드를 위한 AMI 이미지를  빌드 합니다

Build
----------
- 먼저 환경 변수를 확인 하세요.
```shell
echo "AWS_PROFILE: $AWS_PROFILE, AWS_REGION: $AWS_REGION, AWS_OWNER: $AWS_OWNER"
```
- ubuntu 기본 이미지 기반으로 redis EKS Node 이미지를 빌드 합니다.
```shell

# project 체크아웃
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook

cat > ./ansible/playbook-eks-redis.yml << EOF
---
- name: Building redis EKS Node Image
  hosts: all
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: aws-cli
    - role: sudo
    - role: aws-eks
      disk_part: false
    - role: docker-redis
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin
        project: tools
        upload: false
      image:
        name: redis
        tag: 6.2
    - role: cleansing

EOF

packer validate ./packer/eks-redis/ubuntu/build.json

packer build ./packer/eks-redis/ubuntu/build.json
```

Run
----------
```shell
docker run -d --name=redis -p 6379:6379 harbor.toolchain/tools/redis:6.2
```

Appendix
----------

- [Packer build](ubuntu/build.json) 참고 

제약사항
----------
None
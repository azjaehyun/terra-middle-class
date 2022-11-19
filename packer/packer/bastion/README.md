# Bastion AMI

Bastion의 정의된 설치 목록과 기본 "Ubuntu 18.04" 기반으로 빌드 합니다 


Build
----------
- 먼저 환경 변수를 확인 하세요.
```shell
echo "AWS_PROFILE: $AWS_PROFILE, AWS_REGION: $AWS_REGION, AWS_OWNER: $AWS_OWNER"
```
- 기본 ubuntu 18.04 이미지 기반으로 AMI를 빌드 합니다 
```shell
# project 체크아웃
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook

cat > ./ansible/playbook-bastion.yml << EOF
---
- name: Building AWS Bastion AMI Image
  hosts: all
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: bastion
    - role: postgressql-client
      version: 12
    - role: cleansing
EOF

packer validate ./packer/bastion/ubuntu/build.json

packer build ./packer/bastion/ubuntu/build.json
```

Appendix
----------

- [Packer build](ubuntu/build.json) 참고 

제약사항
----------
None

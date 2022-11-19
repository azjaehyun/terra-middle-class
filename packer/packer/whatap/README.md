# whatap AMI

"Ubuntu 18.04" 기반으로 빌드 하고 와탭 수집서버를 설치합니다.
WhaTap server version은 1.40.2 입니다. 1.40.2 버전은 오직 jdk 1.8만 실행 가능합니다.

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

cat > ./ansible/playbook-whatap.yml << EOF
---
- name: Building AWS Whatap AMI Image
  hosts: all
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: java
      java_packages:
        - openjdk-8-jdk
      default_jdk: "openjdk-8-jdk"
    - role: whatap
    - role: cleansing
EOF

packer validate ./packer/whatap/ubuntu/build.json

packer build ./packer/whatap/ubuntu/build.json
```

Appendix
----------

- [Packer build](ubuntu/build.json) 참고 

제약사항
----------
None

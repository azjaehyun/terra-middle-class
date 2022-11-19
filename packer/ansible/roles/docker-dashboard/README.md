Role Name
=========

Dashboard 도커 이미지를 빌드하고 harbor 에 업로드 합니다.

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
---
# 아래는 harbor를 액세스 하기 위한 필수 필수 정의 변수 입니다.
harbor:
  domain: harbor.devapp.shop
  username: admin
  password: admin123$
  project: tools
  upload: false
```

Dependencies
------------

도커 이미지를 빌드 하기위해 docker role 이 포함 되어야 합니다.

Example Playbook
----------------
아래는 playbook 예제 입니다.

```yaml
---
- name: Building Dashboard docker images
  hosts: all
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: docker-dashboard
      harbor:
        domain: harbor.devapp.shop
        username: admin
        password: admin
        project: kubernetesui
        upload: false
```


Example Packer Build
----------------
- ubuntu 기본 이미지 기반으로 Spinnaker 도커 이미지를 빌드 합니다.
```shell
# 환경 변수 설정 샘플
export AWS_PROFILE=dxterra
export AWS_REGION=ap-northeast-2
export AWS_OWNER=827519537363

# 환경 변수 확인
echo "AWS_PROFILE: $AWS_PROFILE, AWS_REGION: $AWS_REGION, AWS_OWNER: $AWS_OWNER"

# project 체크아웃
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook

cp ./example/docker-dashboard/playbook-dashboard-docker.yml ./ansible/

packer validate ./packer/docker-dashboard/ubuntu/dashboard-docker-build.json

# ami 빌드 
packer build ./packer/docker-dashboard/ubuntu/dashboard-docker-build.json
```


License
-------
BSD

Author Information
------------------

write by symplesims


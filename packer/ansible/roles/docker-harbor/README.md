Role Name
=========
harbor 도커 이미지를 빌드 합니다.


Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
---
harbor:
  domain: harbor.toolchain
  username: admin
  password: admin123$
  project: tools/harbor
  upload: false
# mandatory variables for docker image
image:
  tag: v2.3.0
```


Dependencies
------------
None


Build
----------------

```shell

git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker-harbor.yml <<EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: docker
    - role: docker-harbor
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin123$
        project: tools/harbor
        upload: false
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker-harbor.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)
- [harbor 배포버전 확인](https://github.com/goharbor/harbor/releases)
- [docker image](https://github.com/goharbor/harbor/blob/master/make/photon/prepare/templates/docker_compose/docker-compose.yml.jinja)  
```yaml
# "image:" 키워드로 검색 하면 harbor 서비스를 구성하는 도커 이미지를 확인 가능 
version: '2.3'
services:
  registry:
    image: goharbor/registry-photon:{{reg_version}}
    container_name: registry
    restart: always
  ...
```
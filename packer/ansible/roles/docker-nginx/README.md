Role Name
=========

nginx 도커 이미지를 빌드하여 harbor 에 업로드 합니다.

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
---
# 아래는 harbor를 액세스 하기 위한 필수 필수 정의 변수 입니다.
harbor:
  domain: harbor.toolchain
  username: admin
  password: admin123$
  project: tools
  upload: false

# 아래는 docker 이미지의 이름과 태그 정보를 위한 위한 필수 정의 변수 입니다.
# tag 속성은 nginx 버전 입니다. 현재 1.18, 1.19 를 지원하고 있습니다.
image:
  name: dxnginx
  tag: 1.19
```

Dependencies
------------


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker-nginx.yml <<EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: docker
    - role: docker-nginx
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin
        project: tools
        upload: false
      image:
        name: nginx
        tag: 1.21.0
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker-nginx.yml
```

Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)
- [hub.docker.com](https://hub.docker.com/_/nginx)
- [github.com](https://github.com/nginxinc/docker-nginx)


Role Name
=========

kiali 도커 이미지를 빌드하고 harbor 에 업로드 합니다.

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
---
harbor:
  domain: harbor.toolchain
  username: admin
  password: admin!234
  project: tools
  upload: false
```

Dependencies
------------

도커 이미지를 빌드 하기위해 docker role 이 포함 되어야 합니다.


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker-kiali.yml << EOF
---
- name: Building kiali docker images
  hosts: all
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: docker-kiali
      harbor:
        domain: harbor.devapp.shop
        username: admin
        password: admin!234
        project: kiali
        upload: false
EOF

# ansible playbook 빌드
ansible-playbook -i ./inventory.yml ./playbook-docker-kiali.yml
```


Run
----------------


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)


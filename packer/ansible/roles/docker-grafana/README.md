Role Name
=========

grafana 도커 이미지를 빌드하고 harbor 에 업로드 합니다.

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
---
# mandatory variables for harbor
harbor:
  domain: harbor.toolchain
  username: admin
  password: admin123$
  project: tools
  upload: false
# mandatory variables for docker image
image:
  name: grafana
  tag: 8.0.3
```


Dependencies
------------


Build
----------------

```shell

git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker-grafana.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: docker
    - role: docker-grafana
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin123$
        project: tools
        upload: false
      image:
        name: grafana
        tag: 8.0.3
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker-grafana.yml
```

Run
----------------
```
```

Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)

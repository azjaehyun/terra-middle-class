Role Name
=========

Logstash 도커 이미지를 빌드하고 harbor 에 업로드 합니다.

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
---
harbor:
  domain: harbor.toolchain
  username: admin
  password: admin123$
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

cat > ./playbook-docker-logstash.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - group_vars/defaults.yml
  roles:
    - role: sudo
    - role: docker  
    - role: docker-logstash
      image:
        name: logstash
        tag: 7.14.0
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin123$
        project: tools
        upload: false
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker-logstash.yml
```

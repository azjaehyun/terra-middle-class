Role Name
=========

postgressql-client 패키지를 설치 합니다

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
# defaults variable for packer
version: "12"
``` 

Dependencies
------------
None.

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-postgressql-client.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: postgressql-client
      version: 12
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-postgressql-client.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)

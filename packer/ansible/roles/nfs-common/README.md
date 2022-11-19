Role Name
=========

nfs  패키지를 설치 합니다 

Role Variables
--------------
None 

Dependencies
------------
None.

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-nfs-common.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: nfs-common
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-nfs-common.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)


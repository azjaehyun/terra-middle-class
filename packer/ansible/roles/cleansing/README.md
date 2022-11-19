Role Name
=========

apt install 을 오류 없이 실행하기 위한 Role 입니다 

Role Variables
--------------
None 

Dependencies
------------
None 

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-cleansing.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: cleansing
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-cleansing.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventoryyml-샘플)


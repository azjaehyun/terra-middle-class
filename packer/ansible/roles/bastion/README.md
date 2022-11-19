Role Name
=========

Bastion OS 구성에 필요한 패키지를 설치 합니다. 

Role Variables
--------------


Dependencies
------------
    - unzip 
    - packer
    - terraform
    - aws-cli
    - istioctl
    - kubectl
    - aws-iam-authenticator
    - ansible
    - helm
    - java
    - halyard

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-bastion.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: bastion
    - role: postgressql-client
      version: 12
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-bastion.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventoryyml-샘플)


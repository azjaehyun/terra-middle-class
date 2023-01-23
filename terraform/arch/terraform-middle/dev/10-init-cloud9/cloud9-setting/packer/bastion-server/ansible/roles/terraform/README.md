Role Name
=========

terraform 패키지를 설치 합니다 

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
# defaults variable for packer
terraform_version: "0.14.0"
# terraform release url - https://releases.hashicorp.com/terraform/
terraform_download_url: "https://releases.hashicorp.com/terraform/{{ terraform_version }}/terraform_{{ terraform_version }}_linux_amd64.zip"
``` 

Dependencies
------------
None.

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-terraform.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: terraform
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-terraform.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)


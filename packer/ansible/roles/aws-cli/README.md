Role Name
=========

aws-cli 패키지를 설치 합니다

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
cli_download_url: "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
```

Dependencies
------------
- unzip


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-aws-cli.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: aws-cli
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-aws-cli.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventoryyml-샘플)


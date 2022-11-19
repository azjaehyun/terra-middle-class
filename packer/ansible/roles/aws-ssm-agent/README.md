Role Name
=========

aws-ssm-agent 패키지를 설치 합니다

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
# defaults file for aws-ssm
url: "amd64"
```
Dependencies
------------
None.


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-aws-ssm-agent.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: aws-ssm-agent
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-aws-ssm-agent.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventoryyml-샘플)


Role Name
=========

aws-iam-authenticator 패키지를 설치 합니다

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
# aws-authenticator_download
aws_iam_authenticator_download: "https://amazon-eks.s3.us-west-2.amazonaws.com/{{ kubernetes_version }}/{{ kubernetes_build_date }}/bin/linux/amd64/aws-iam-authenticator"

# iam_authenticator dependencies
kubernetes_version: "1.19.6"
kubernetes_build_date: "2021-01-05"
```
Dependencies
------------


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-aws-iam-authenticator.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: aws-iam-authenticator
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-aws-iam-authenticator.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventoryyml-샘플)


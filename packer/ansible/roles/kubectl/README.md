Role Name
=========

kubectl 패키지를 설치 합니다 

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
kubernetes_version: "1.19.6"
kubernetes_build_date: "2021-01-05"

# s3_kubectl_download: "https://amazon-eks.s3.{{ aws_region }}.{{ aws_s3_domain }}/{{ kubernetes_version }}/{{ kubernetes_build_date }}/bin/linux/amd64/kubectl"
kubectl_download: "https://amazon-eks.s3.us-west-2.amazonaws.com/{{ kubernetes_version }}/{{ kubernetes_build_date }}/bin/linux/amd64/kubectl"
```

Dependencies
------------
None.

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-kubectl.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: kubectl

EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-kubectl.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)


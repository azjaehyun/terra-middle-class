Role Name
=========

istioctl 패키지를 설치 합니다 

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
# istioctl version / down_load_url 
istio_version: "1.9.2"
istio_download_url: "https://istio.io/downloadIstio"
```

Dependencies
------------
None.

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-istioctl.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: istioctl
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-istioctl.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)


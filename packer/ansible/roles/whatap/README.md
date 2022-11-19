Role Name
=========
whatap 수집기 서버를 설치 합니다.

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
whatap_server_type: "single"
whatap_license: "insert license.."
```

Dependencies
------------
- java ( jdk 1.8 )


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-whatab.yml << EOF
---
- name: Building AWS Bastion AMI Image
  hosts: all
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: java
      java_packages:
        - openjdk-8-jdk
        - openjdk-11-jdk
      default_jdk: "openjdk-8-jdk"
    - role: whatap
      whatap_server_type: "single"
    - role: cleansing
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-whatab.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventoryyml-샘플)


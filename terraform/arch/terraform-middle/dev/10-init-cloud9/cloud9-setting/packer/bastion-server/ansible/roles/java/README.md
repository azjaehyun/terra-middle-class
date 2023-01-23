Role Name
=========

java

Variables
--------------
[defaults/main.yaml](./defaults/main.yml)

| java_packages     | description   |
| -------           | ------------  |
| openjdk-8-jdk     |  OpenJDK Development Kit (JDK) 1.8 version |
| openjdk-11-jdk    |  OpenJDK Development Kit (JDK) 11 version |



Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-java.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - group_vars/defaults.yml
  roles:
    - role: sudo
    - role: java
      java_packages:
      - openjdk-8-jdk
      - openjdk-11-jdk
      default_jdk: openjdk-8-jdk
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-java.yml
```

Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)

Role Name
=========

halyard 패키지를 설치합니다.

Precautions
----------------
- Halyard 가 동작하려면 Java 11 이상 설치 및 구성 되어 있어야 합니다. 


Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
harbor:
  domain: harbor.toolchain
  username: admin
  password: admin123$
  project: tools
image:
  name: gitlab-ce # gitlab-ce, gitlab-ee 
  tag: 13.10.3-ce # 13.10.2-ee, 13.10.3-ce
```

Dependencies
------------


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-halyard.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: java
      java_packages:
      - openjdk-11-jdk
    - role: halyard
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-halyard.yml
```

Checking
----------------
````shell
java --version
hal -v
````

Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)

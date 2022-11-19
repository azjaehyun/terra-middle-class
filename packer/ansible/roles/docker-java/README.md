Role Name
=========

Java 도커 이미지를 빌드 합니다.


Precautions
----------------
- 빌드된 Docker 이미지를 harbor 에 업로드 하기위해선 harbor에 액세스 할 수 있어야 합니다.
- harbar 의 내부 도메인은 harbor.toolchain 이며, tools 프로젝트가 사전에 생성되어 있어야 합니다.
- harbor.upload 속성이 true 라면 harbor 저장소에 업로드 합니다. (default: false)


Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
harbor:
  domain: harbor.toolchain
  username: admin
  password: admin123$
  project: tools
  upload: false
image:
  name: openjdk11
  tag: ubuntu-slim
```

Dependencies
------------


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker-java.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: docker
    - role: docker-java
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin
        project: tools
        upload: false
      image:
        name: openjdk11
        tag: ubuntu-slim
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker-java.yml
```

Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)
- [hub.docker.com](https://hub.docker.com/r/adoptopenjdk/openjdk11/tags?&name=slim)
- [github.com](https://github.com/AdoptOpenJDK/openjdk-docker)




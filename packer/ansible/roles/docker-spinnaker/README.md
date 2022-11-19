Role Name
=========

spinnaker 도커 이미지를 빌드하고 harbor 에 업로드 합니다.

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
---
harbor:
  domain: harbor.toolchain
  username: admin
  password: admin123$
  project: tools/spinnaker
  upload: false
# spinnaker modules
echo_version: 2.17.1-20210429125836
clouddriver_version: 8.0.3-20210614020020
deck_version: 3.7.2-20210614020020
front50_version: 0.27.0-20210422230020
gate_version: 1.22.1-20210603020019
igor_version: 1.16.0-20210422230020
orca_version: 2.20.2-20210526020021
rosco_version: 0.25.0-20210422230020    
```

Dependencies
------------

도커 이미지를 빌드 하기위해 docker role 이 포함 되어야 합니다.


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker-spinnaker.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - group_vars/defaults.yml
  roles:
    - role: sudo
    - role: docker  
    - role: docker-spinnaker
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin123$
        project: tools/spinnaker
        upload: false
      # spinnaker modules
      echo_version: 2.17.1-20210429125836
      clouddriver_version: 8.0.3-20210614020020
      deck_version: 3.7.2-20210614020020
      front50_version: 0.27.0-20210422230020
      gate_version: 1.22.1-20210603020019
      igor_version: 1.16.0-20210422230020
      orca_version: 2.20.2-20210526020021
      rosco_version: 0.25.0-20210422230020        
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker-spinnaker.yml
```

Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)
- [spinnaker 배포버전 확인](https://spinnaker.io/community/releases/versions/#latest-stable)
```hal
# last-stable 버전이 1.26.4 인 경우 halyard 으로 모듈 버전 확인

hal version bom 1.26.4
```  
- [docker image](https://console.cloud.google.com/artifacts/docker/spinnaker-community/us/docker)
- [spinnaker github](https://github.com/spinnaker)
```
https://github.com/spinnaker/echo.git
https://github.com/spinnaker/clouddriver.git
https://github.com/spinnaker/deck.git
https://github.com/spinnaker/front50.git
https://github.com/spinnaker/gate.git
https://github.com/spinnaker/igor.git
https://github.com/spinnaker/orca.git
https://github.com/spinnaker/rosco.git
```

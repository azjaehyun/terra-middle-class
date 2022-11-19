Role Name
=========

Gitlab 도커 이미지를 빌드하고 harbor 저장소에 업로드 합니다.

Precautions
----------------
- Gitlab Docker 빌드 이미지는 [omnibus-gitlab-docker](https://gitlab.com/gitlab-org/omnibus-gitlab/-/tree/master/docker) 를 참조 하세요
- Gitlab 배포 패키지는 [https://packages.gitlab.com/gitlab/](https://packages.gitlab.com/gitlab/) 에 있습니다. 
- Docker 빌드를 위해서 [RELEASE](https://gitlab.com/gitlab-org/omnibus-gitlab/-/blob/master/doc/build/build_docker_image.md#release-file) 파일을 작성해야 합니다. 
- 빌드된 Docker 이미지를 harbor 에 업로드 하기위해선 harbor에 액세스 할 수 있어야 합니다.
- harbar 의 내부 도메인은 harbor.toolchain 이며, tools 프로젝트가 사전에 생성되어 있어야 합니다.
- Gitlab 저장소를 위해 1 TB 크기 이상의 EBS Volume과 사전 파티셔닝 작업을 권장 합니다.


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
  name: gitlab-ce # gitlab-ce, gitlab-ee 
  tag: 13.10.3-ce # 13.10.2-ee, 13.10.3-ce, 13.12.4-ce
```

Dependencies
------------


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker-gitlab-runner.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: docker
    - role: docker-gitlab-runner
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin123$
        project: tools
        upload: false
      image:
        name: gitlab-runner
        tag: v13.12
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker-gitlab-runner.yml
```

Run
----------------
```
```

Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)

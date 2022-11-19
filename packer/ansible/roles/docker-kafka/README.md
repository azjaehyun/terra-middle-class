Role Name
=========

docker-kafka 

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
---
java_base_image: "adoptopenjdk/openjdk11:jdk-11.0.12_7-ubuntu-slim"

kafka:
  version: 3.0.0
  homedir: /opt/kafka
  scala_version: 2.13

download_url: "https://archive.apache.org/dist/kafka/{{ kafka.version }}/kafka_{{ kafka.scala_version }}-{{ kafka.version }}.tgz"
download_target: "/tmp/kafka-{{ kafka.scala_version }}-{{ kafka.version }}.tar.gz"

# mandatory variables for harbor
harbor:
  domain: harbor.toolchain
  username: admin
  password: admin123$
  project: tools
  upload: false

# mandatory variables for docker image
image:
  name: kafka-kraft
  tag: "{{ kafka.version }}"
```

Dependencies
------------


Variables
--------------
[defaults/main.yaml](./defaults/main.yml)

| variables             | description   |
| -------               | ------------  |
| kafka.version         | kafka 버전을 정의 합니다. |
| kafka.homedir         | kafka 설치 홈 디렉토리를 정의 합니다.|
| kafka.scala_version   | scala 버전을 정의 합니다. |
| java_base_image       | java 런타임 환경을 위한 docker from 베이스 이미지를 정의 합니다. (default: adoptopenjdk/openjdk11:jdk-11.0.12_7-ubuntu-slim") |
| download_url          | kafka 다운로드 url 정보 입니다. |
| download_target       | kafka 설치 타겟 파일 경로 입니다. |
| harbor.domain         | Harbor public 도메인 입니다. |
| harbor.username       | Harbor 사용자 아이디 입니다. |
| harbor.password       | Harbor 사용자 패스워드 입니다. |
| harbor.project        | 도커 이미지를 업로드할 harbor 프로젝트 저장소 입니다. |
| harbor.upload         | 도커 이미지를 빌드한 이후에 harbor 저장소에 업로드 하려면 true 로 하세요. (default: false) |
| image.name            | 도커 이미지 이름 입니다. |
| image.tag             | 도커 이미지 태그 입니다. (default: kafka.version  ) |


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker-kafka.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - group_vars/defaults.yml
  roles:
    - role: sudo
    - role: docker
    - role: docker-kafka
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker-kafka.yml
```

Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)
- [Kubernetes 배포 샘플](./kafka-sts.md)
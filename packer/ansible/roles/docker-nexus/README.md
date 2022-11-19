Role Name
=========

Nexus 도커 이미지를 빌드하고 harbor 저장소에 업로드 합니다.


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
  name: nexus3
  tag: 3.31.0
```

Dependencies
------------
 

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker-nexus.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: docker
    - role: docker-nexus
      harbor:
        domain: harbor.devapp.shop
        username: admin
        password: admin123$
        project: tools
        upload: false
      image:
        name: nexus3
        tag: 3.31.0
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker-nexus.yml
```

Run
----------------
nexus 컨테이너 구동 및 로그 확인 
````shell
docker run -d -p 8081:8081 --name nexus harbor.toolchain/tools/nexus:3.31.0

docker logs -f nexus
````


Keycloak Plugin
----------------
- [nexus3-keycloak-plugin](https://github.com/flytreeleft/nexus3-keycloak-plugin) 프로젝트를 maven 을 통해 build 할 수 있습니다.
pom.xml 파일에서 nexus 와 keycloak 를 통할 할 수 있는 버전을 맞추어야 합니다.  
- org.sonatype.nexus.plugins.nexus-plugins
- keycloak.version 
```
    <parent>
        <groupId>org.sonatype.nexus.plugins</groupId>
        <artifactId>nexus-plugins</artifactId>
        <version>3.31.0-01</version>
    </parent>
    <properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <keycloak.version>13.0.0</keycloak.version>
    </properties>
```
maven 을 통해 빌드를 수행 합니다. 주의할 사항으로 maven.compiler.source, maven.compiler.target 에 맞는 Java 버전을 설정 하세요.
```shell
git clone https://github.com/flytreeleft/nexus3-keycloak-plugin.git
cd nexus3-keycloak-plugin
# Edit pom.xml (see above)
mvn clean install -Dmaven.test.skip=true
```
빌드된 이미지는 docker-nexus/files/nexus3-keycloak-plugin 하위에 version 에 맞게 추가 하세요.

- [nexus-docker-image](https://github.com/FireBlinkLTD/docker-nexus-keycloak/blob/master/Dockerfile)
- [nexus-plugin](https://mvnrepository.com/artifact/org.sonatype.nexus.plugins/nexus-plugins)


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)

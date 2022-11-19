Role Name
=========

[sonarqube](https://www.sonarqube.org/) 도커 이미지를 빌드하고 [harbor](https://harbor.org/) 저장소에 업로드 합니다.


Precautions
----------------
- Sonarqube 배포 패키지는 [https://www.sonarqube.org/](https://www.sonarqube.org/) 에 있습니다.
- Sonarqube docker hub 프로젝트는 [https://hub.docker.com/_/sonarqube](https://hub.docker.com/_/sonarqube) 에 있습니다.
- [Sonarqube Docker 이미지](https://github.com/SonarSource/docker-sonarqube) 빌드는 참조 하세요
- 빌드된 Docker 이미지를 harbor 에 업로드 하기위해선 harbor에 액세스 할 수 있어야 합니다.
- harbar 의 내부 도메인은 harbor.toolchain 이며, tools 프로젝트가 사전에 생성되어 있어야 합니다.
- Sonarqube 의 내부 도메인은 sonarqube.toolchain 으로 정의 합니다.
- apt-get update 시 connection 오류 발생시 보안 그룹을 확인 하여야 합니다.

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
  name: sonarqube
  tag: 8.9.1-community
oidc_plugin:
  enable: true
  version: 2.0.0
```

Dependencies
------------

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker-sonarqube.yml << EOF
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
    - role: docker
    - role: docker-sonarqube
      image:
        name: sonarqube
        tag: 8.9.1-community
      oidc_plugin:
        enable: true
        version: "2.0.0"        
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker-sonarqube.yml
```

Run
----------------

docker 를 통해 sonarqube 컨테이너를 실행 합니다.
- External DB 를 참조하는 경우 예제

```
docker run --detach --name sonarqube \
  --stop-timeout 3600 \
  -p 9000:9000 \
  -e SONARQUBE_JDBC_USERNAME=sonarqube \
  -e SONARQUBE_JDBC_PASSWORD=sonarqube123$ \
  -e SONARQUBE_JDBC_URL=jdbc:postgresql://database.toolchain:5432/sonarqube \
harbor.toolchain/tools/sonarqube:8.9.1-community

# 참고로 max_map_count 메모리 관련하여 오류가 발생 하면 max_map_count 값을 늘려 주면 됨 
# sudo sysctl -w vm.max_map_count=262144

# log 확인 
# docker logs -f sonarqube
```

### kubernetes deployment descriptor example
```yaml
cat > ./deploy-sonarqube.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: toolchain
  labels:
    toolchain: sonarqube
  name: sonarqube
spec:
  replicas: 1
  selector:
    matchLabels:
      toolchain: sonarqube
  template:
    metadata:
      labels:
        toolchain: sonarqube
    spec:
      containers:
      - name: sonarqube
        image: harbor.toolchain/tools/sonarqube:6.2
        imagePullPolicy: IfNotPresent
        env:
          - name: SONARQUBE_JDBC_PASSWORD
            value: "sonarqube!234"
          - name: SONARQUBE_JDBC_URL
            value: "jdbc:postgresql://database.toolchain:5432/sonarqube"
          - name: SONARQUBE_JDBC_USERNAME
            value: "sonarqube"        
        ports:
        - containerPort: 9000
      nodeSelector:
        eks.amazonaws.com/nodegroup: ${cluster_name}-sonarqube-node

---
apiVersion: v1
kind: Service
metadata:
  name: sonarqube-service
  namespace: toolchain
  labels:
    toolchain: sonarqube
spec:
  type: ClusterIP
  ports:
  - protocol: TCP
    name: sonarqube
    port: 9000
    targetPort: 9000
  selector:
      toolchain: sonarqube
EOF

kubectl -f ./deploy-sonarqube.yaml
```

Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)
- [sonarqube-docker-hub](https://hub.docker.com/_/sonarqube)
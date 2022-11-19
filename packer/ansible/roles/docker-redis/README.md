Role Name
=========

Redis 도커 이미지를 빌드하고 harbor 저장소에 업로드 합니다.

Precautions
----------------
- 빌드된 Docker 이미지를 harbor 에 업로드 하기위해선 harbor에 액세스 할 수 있어야 합니다.
- harbar 의 내부 도메인은 harbor.toolchain 이며, tools 프로젝트가 사전에 생성되어 있어야 합니다.


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
  name: redis
  tag: 6.2
```

Dependencies
------------

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker-redis.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: docker
    - role: docker-redis
      harbor:
        domain: harbor.toolchain
        username: admin
        password: admin123$
        project: tools
        upload: false
      image:
        name: redis
        tag: 6.2
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker-redis.yml
```

Run
----------------

docker 를 통해 redis 컨테이너를 실행 합니다.
```
docker run --name redis -d -p 6379:6379 harbor.toolchain/tools/redis:6.2
```

### kubernetes deployment descriptor example
```yaml
cat > ./deploy-redis.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: toolchain
  labels:
    toolchain: redis
  name: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      toolchain: redis
  template:
    metadata:
      labels:
        toolchain: redis
    spec:
      containers:
      - name: redis
        image: harbor.toolchain/tools/redis:6.2
        imagePullPolicy: IfNotPresent
        args: ["--requirepass", "${redis_password}"]
        ports:
        - containerPort: 6379
      nodeSelector:
        eks.amazonaws.com/nodegroup: ${cluster_name}-redis-node

---
apiVersion: v1
kind: Service
metadata:
  name: redis-service
  namespace: toolchain
  labels:
    toolchain: redis
spec:
  type: ClusterIP
  ports:
  - protocol: TCP
    name: redis
    port: 6379
    targetPort: 6379
  selector:
      toolchain: redis
EOF

kubectl -f ./deploy-redis.yaml
```

Checking
----------------
redis 컨테이너 내부에서 redis-cli 를 통해 정상 접속이 되는지 확인 합니다.
```
docker exec -it redis /bin/bash

# inside redis container
redis-cli
127.0.0.1:6379> auth redis!234
OK
127.0.0.1:6379>
```

Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)

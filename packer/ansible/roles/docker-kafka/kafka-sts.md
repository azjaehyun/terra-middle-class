# Deploy Kafka Cluster with Kraft Mode

Kafka 클러스터 배포는 Kubernetes 환경에서만 배포 할 수 있습니다.

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: kafka

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: kafka-pvc
  namespace: kafka
spec:
  storageClassName: gp2
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi

---
apiVersion: v1
kind: Service
metadata:
  name: kafka-service
  labels:
    app: kafka
  namespace: kafka
spec:
  type: ClusterIP
  ports:
    - name: listener
      protocol: TCP
      port: 9092
      targetPort: 9092
    - name: broker
      protocol: TCP
      port: 9093
      targetPort: 9093
  selector:
    app: kafka

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: kafka
  labels:
    app: kafka
  namespace: kafka
spec:
  serviceName: kafka-service
  replicas: 3
  selector:
    matchLabels:
      app: kafka
  template:
    metadata:
      labels:
        app: kafka
    spec:
      nodeSelector:
        eks-nodegroup: kafka      
      containers:
        - name: kafka
          image: harbor.toolchain/tools/kafka-kraft:3.0.0
          ports:
            - containerPort: 9092
            - containerPort: 9093
          env:
            - name: REPLICAS
              value: '3'
            - name: SERVICE
              value: kafka-service
            - name: NAMESPACE
              value: kafka
            - name: SHARE_DIR
              value: /mnt/kafka
          volumeMounts:
            - name: kafka-storage
              mountPath: /mnt/kafka
      volumes:
        - name: kafka-storage
          persistentVolumeClaim:
            claimName: kafka-pvc
```

- Kafka Pod는 StatefulSet 으로만 배포 하여야 합니다.
```
apiVersion: apps/v1
kind: StatefulSet
```

- Pod 이름은 반드시 kafka 여야만 합니다.
```
metadata:
  name: kafka
```

- 서비스 리소스, 서비스이름(serviceName), 컨테이너 Env vars 의 SERVICE 환경 변수 값은 반드시 일치 하여야 합니다.  
  예) serviceName 이 "kafka-service" 인 경우, env 의 SERVICE 값도 "kafka-service" 이여야 합니다.
```yaml
apiVersion: v1
kind: Service
metadata:
  name: kafka-service               # here

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: kafka
spec:
  serviceName: kafka-service        # here
...
  template:
    spec:    
      containers:
          env:
            - name: SERVICE
              value: kafka-service  # here
```

  
- replicas 과 컨테이너 Env vars 의 REPLICAS 환경 변수 값은 반드시 일치 하여야 합니다.  
  예) replicas 값이 3 인 경우, env 의 REPLICAS 값도 '3' 이여야 합니다. (참고로, REPLICAS Env 값은 문자형으로 설정 하세요) 
```yaml
spec:
  replicas: 3
...
  template:
    spec:    
      containers:
          env:
            - name: REPLICAS
              value: '3'
```

- 네임스페이스완 컨테이너 Env vars 의 NAMESPACE 환경 변수 값은 반드시 일치 하여야 합니다.  
  예) namespace 값이 "kafka" 인 경우, env 의 NAMESPACE 값도 "kafka" 이여야 합니다.
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  namespace: kafka
...
  template:
    spec:    
      containers:
          env:
            - name: NAMESPACE
              value: kafka  
```

- PersistentVolumeClaim 영속적인 볼륨을 사전에 준비 되어야 합니다.
```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: kafka-pvc
  namespace: kafka

```
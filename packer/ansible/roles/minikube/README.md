Role Name
=========

Minikube 패키지를 설치 합니다. 


Pre-Requisite
--------------
- minikube 는 단일 클러스터의 kubernetes 리소스를 테스트하기 위한 용도 이므로 서비스용으로 적합하지 않습니다.
- gitlab 과 같은 많은 리소스가 필요로 하는 경우 적당한 cpu, memory, disk volume 을 사용하길 권고 합니다.
최소 권장) 2 core, 8 GB memory, 100 GB disk volume - (EC2 인 경우 최소 t3 medium 이상 사용하세요.)
- minikube 를 docker 드라이브로 실행하기 위해 ubunut 사용자 그룹을 docker 로 변경 합니다.
```shell
sudo usermod -aG docker ubuntu && newgrp docker
```


Minikube
--------------
Minikube 는 host 환경 또한 가상환경으로 구성 됩니다.
**minikube ssh** 명령을 통해 minikube host 환경에 접속 할 수 있습니다.
```shell
ubuntu@localhost$ minikube ssh
Last login: Thu Jul  8 05:46:11 2021 from 192.168.49.1
docker@minikube:~$
docker@minikube:~$
```

- 참고 사항으로, 컨테이너에서 바라보는 경로의 실제 HOST 기준 경로는 "/var/lib/docker/volumes/minikube/_data" 입니다.
```yaml
volumes:
- name: gitlab-data
  hostPath:
    path: /data/gitlab-data
```
위와 같이 '/data/gitlab/data' 를 마운트 하면 실제 경로는 '/var/lib/docker/volumes/minikube/_data/data/gitlab-data' 입니다. 



Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
# https://github.com/kubernetes/minikube/releases
minikube_version: 1.20.0
```


Dependencies
------------


Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-minikube.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: nfs-common
    - role: kubectl
    - role: helm
    - role: docker
    - role: minikube
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-minikube.yml
```

Run
----------------
Kubectl autocomplete 설정 
 
```shell
# ssh -i ~/.ssh/<YOUR_SSH_PEM_KEY> ubuntu@<YOUR_REMOTE_IP_ADDR>

source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
alias k=kubectl
complete -F __start_kubectl k
alias mstart='minikube start --driver=docker'
alias mstop='minikube stop'

```

minikube 구동 및 pod 확인
```shell
minikube start --driver=docker
kubectl get po -A
```

Nginx Ingress
----------------

nginx ingress 플러그인을 addon 하고 kubectl 을 통해 리소스가 생성되었는지 확인
```shell
minikube addons enable ingress
kubectl get pods -n ingress-nginx
```

샘플 애플리케이션을 배포하고 외부에서 확인
```shell
kubectl create deployment hello --image=gcr.io/google-samples/node-hello:1.0 --replicas=2 --port=8080

kubectl expose deployment hello --type=LoadBalancer --name=hello-service
```

Deploy Sample Applications
----------------
- [busybox](./files/samples/busybox/README.md)
- [postgresql](./files/samples/postgresql/README.md)
- [gitlab](./files/samples/gitlab/README.md)
- [gitlab-runner](./files/samples/gitlab-runner/README.md)
- [sonarqube](./files/samples/sonarqube/README.md)
- [nexus](./files/samples/nexus/README.md)
- [grafana](./files/samples/grafana/README.md)


Appendix
----------------
- minikube configuration file
````shell
~/.minikube/machines/minikube/config.json
````

- [inventory.yml 템플릿 참고](../../../README.md#inventory-example)


# postgres
postgresql pod 를 배포 합니다.


Pre-Requisite
---------------
sonarqube 사용자 및 데이터베이스 생성 
```
# SSH conntecting
ssh -i <YOUR_PEM_FILE_LOCATION> ubuntu@<PUBLIC_IP_ADDRESS>

kubectl exec -it $(kubectl get pod -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- /bin/bash

# in container postgresql-xxxx
psql -U gitlab
create database sonarqube;
create user sonarqube password 'sonarqube123$';
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;
 
```
Deploy
---------------

```
# SSH conntecting
ssh -i <YOUR_PEM_FILE_LOCATION> ubuntu@<PUBLIC_IP_ADDRESS>

kubectl apply -f postgres-cm.yaml

sudo kubectl port-forward --address 0.0.0.0 services/sonarqube-service 9000:9000
```
 
Appendix
---------------
보안 그룹에서 9000 포트에 대한 접근을 허용이 필요할 수 있습니다.
초기 비밀번호는 admin 입니다.

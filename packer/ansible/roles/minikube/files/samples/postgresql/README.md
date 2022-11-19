# postgres
postgresql pod 를 배포 합니다.

Deploy
---------------

```
# SSH conntecting
ssh -i <YOUR_PEM_FILE_LOCATION> ubuntu@<PUBLIC_IP_ADDRESS>

kubectl apply -f postgres-cm.yaml

kubectl apply -f postgres-pv.yaml

kubectl apply -f postgres-deploy.yaml

kubectl apply -f postgres-service.yaml
```
 
Appendix
---------------
psql 를 통해 postgresql DB 콘솔에 접속 가능한지 확인 할 수 있습니다.
````shell
kubectl run postgres-client --rm --tty -i --restart='Never' --namespace default \
  --image docker.io/bitnami/postgresql:11.7.0-debian-10-r9 --env="PGPASSWORD=admin123$" \
  --command -- psql --host postgres-service -U gitlab -d gitlab -p 5432

# \du
# \dp  
````

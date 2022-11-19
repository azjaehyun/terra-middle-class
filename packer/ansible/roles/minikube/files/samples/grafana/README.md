# grafana


Deploy
---------------

```
# SSH conntecting
ssh -i ~/.ssh/adxbasic ubuntu@<PUBLIC_IP_ADDRESS>

# deploy ConfigMap
kubectl apply -f grafana-cm.yaml

# deploy pv
kubectl apply -f grafana-pv.yaml

# deploy application
kubectl apply -f grafana-deploy.yaml

# expose service
kubectl apply -f grafana-service.yaml

# port-forwarding for accessing internet-users
sudo kubectl port-forward --address 0.0.0.0 services/grafana-service 80:3000  
```

- AWS 인경우 Security Group 에서 액세스 허용 설정을 해야 합니다.

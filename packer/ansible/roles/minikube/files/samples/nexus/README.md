# nexus


Deploy
---------------

```
# SSH conntecting
ssh -i ~/.ssh/adxbasic ubuntu@<PUBLIC_IP_ADDRESS>

# deploy nexus pv
kubectl apply -f nexus-pv.yaml

# deploy nexus application
kubectl apply -f nexus-deploy.yaml

# expose service
kubectl apply -f nexus-service.yaml

# port-forwarding for accessing internet-users
sudo kubectl port-forward --address 0.0.0.0 services/nexus-service 80:8081  
```

- AWS 인경우 Security Group 에서 액세스 허용 설정을 해야 합니다.

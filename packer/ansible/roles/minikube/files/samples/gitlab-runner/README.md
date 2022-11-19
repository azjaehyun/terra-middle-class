# gitlab-runner


Pre-Requisite
--------------
helm gitlab 리파지토리 등록 
```
sudo helm repo add gitlab https://charts.gitlab.io
sudo helm repo update
```


Deploy
---------------
gitlab-runner 배포
```
# SSH conntecting
ssh -i ~/.ssh/adxbasic ubuntu@<PUBLIC_IP_ADDRESS>

export GITLAB_PUBLIC_HOST="<YOUR_GITLAB_PUBLIC_HOST>"
export RUNNER_REGISTRATION_TOKEN="<YOUR_RUNNERS_TOKEN>" # you can find "Admin dashboard > Runners" menu

# deploy gitlab-runner-rabc
kubectl apply -f gitlab-runner-rbac.yaml

# generate gitlab-runner-secret.yaml
kubectl create secret generic gitlab-runner-secret --from-literal=runner-registration-token="${RUNNER_REGISTRATION_TOKEN}" \
--from-literal=runner-token= --dry-run=client -o yaml > gitlab-runner-secret.yaml

# deploy gitlab-runner-secret.yaml
kubectl apply -f gitlab-runner-secret.yaml

sudo helm install gitlab-runner --set gitlabUrl=http://${GITLAB_PUBLIC_HOST} gitlab/gitlab-runner -f gitlab-runner-deploy-helm.yaml

```


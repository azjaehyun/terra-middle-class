# gitlab


Deploy
---------------

```
# SSH conntecting
ssh -i ~/.ssh/adxbasic ubuntu@<PUBLIC_IP_ADDRESS>

# edit external_url attribute in "gitlab-deploy.yaml" file & deploy it
kubectl apply -f gitlab-deploy.yaml

# expose service (ClusterIP type 으로 생성 합니다.)
kubectl apply -f gitlab-service.yaml

# port-forwarding for accessing internet-users
sudo kubectl port-forward --address 0.0.0.0 services/gitlab-service 80:80  
```

- AWS 인경우 Security Group 에서 액세스 허용 설정을 해야 합니다.


Initialize personal access token & CI/CD Variables 
---------------

```
# setting personal_access_token for root
export ROOT_ACCOUNT="root"
export PERSONAL_ACCESS_TOKEN="ZNcNKcK1qrFMRgSvB2Qjvg"
export GITLAB_PUBLIC_HOST="<YOUR_GITLAB_PUBLIC_HOST>"
kubectl exec -n default -it $(kubectl get pod -n default -l app=gitlab -o jsonpath='{.items[0].metadata.name}') -- gitlab-rails runner "token = User.find_by_username('${ROOT_ACCOUNT}').personal_access_tokens.create(scopes: [:api, :read_user, :read_api, :read_repository, :write_repository], name: 'Automation token'); token.set_token('${PERSONAL_ACCESS_TOKEN}'); token.save!"

curl --request POST --header "PRIVATE-TOKEN: ${PERSONAL_ACCESS_TOKEN}" "http://${GITLAB_PUBLIC_HOST}/api/v4/admin/ci/variables" --form "key=HARBOR_DOMAIN" --form "value=dxharbor.devapp.shop"
curl --request POST --header "PRIVATE-TOKEN: ${PERSONAL_ACCESS_TOKEN}" "http://${GITLAB_PUBLIC_HOST}/api/v4/admin/ci/variables" --form "key=HARBOR_USERNAME" --form "value=admin" 
curl --request POST --header "PRIVATE-TOKEN: ${PERSONAL_ACCESS_TOKEN}" "http://${GITLAB_PUBLIC_HOST}/api/v4/admin/ci/variables" --form "key=HARBOR_PASSWORD" --form "value=admin123$"
curl --request POST --header "PRIVATE-TOKEN: ${PERSONAL_ACCESS_TOKEN}" "http://${GITLAB_PUBLIC_HOST}/api/v4/admin/ci/variables" --form "key=SPINNAKER_DOMAIN" --form "value=spin.devapp.shop" 
curl --request POST --header "PRIVATE-TOKEN: ${PERSONAL_ACCESS_TOKEN}" "http://${GITLAB_PUBLIC_HOST}/api/v4/admin/ci/variables" --form "key=SPINNAKER_WEBHOOK_SECRET_KEY" --form "value=fgygXYoJKpLtaBScNodeg" 

curl --header "PRIVATE-TOKEN: ${PERSONAL_ACCESS_TOKEN}" "http://${GITLAB_PUBLIC_HOST}/api/v4/runners"
```

Appendix
---------------

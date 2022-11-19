# Docker-Eksnode-Build
Kubernetes 워커 노드용 ami 도커 베이스 이미지를 harbor 로부터 다운로드 합니다.

Build
----------------
```
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook

# 원하는 playbook 을 참조하여 프로비저닝 합니다. 
(예: playbook-dxjava-eksnode.yml, playbook-dxnginx-eksnode.yml, ...)

cp ./example/docker-eksnode-build/playbook-dxjava-eksnode.yml ./ansible/

ansible-playbook -i inventory.yml playbook-dxjava-eksnode.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../README.md#inventoryyml-샘플)

- [playbook-playbook-dxjava-eksnode.yml 참고](../../example/docker-eksnode-build/playbook-dxjava-eksnode.yml)

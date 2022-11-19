# DX-Docker-Harbor
harbor 도커 이미지를 빌드하여 harbor 에 업로드 합니다.

Build
----------------
```
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cp ../example/docker-harbor/playbook-harbor-docker.yml ./ 

ansible-playbook -i inventory.yml playbook-harbor-docker.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../README.md#inventoryyml-샘플)

- [playbook-harbor-docker.yml 참고](../../example/docker-harbor/playbook-harbor-docker.yml)

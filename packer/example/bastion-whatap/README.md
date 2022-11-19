# Bastion 
Bastion에 정의한 설치 목록을 프로비저닝 합니다 

Build
----------------
```
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cp ../example/bastion-whatap/playbook-bastion-whatap.yml ./ 

ansible-playbook -i inventory.yml playbook-bastion-whatap.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../README.md#inventoryyml-샘플)

- [playbook-bastion-whatap.yml 참고](./playbook-bastion-whatap.yml)

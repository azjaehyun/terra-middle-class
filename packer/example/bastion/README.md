# Bastion 
Bastion에 정의한 설치 목록을 프로비저닝 합니다 

Build
----------------
```
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cp ../example/bastion/playbook-bastion.yml ./ 

ansible-playbook -i inventory.yml playbook-bastion.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../README.md#inventoryyml-샘플)

- [playbook-bastion.yml 참고](./playbook-bastion.yml)

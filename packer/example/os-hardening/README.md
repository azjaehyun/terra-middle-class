# os-hardening
OS 골든 이미지를 만들기 위한 하드닝 작업을 프로비저닝 합니다.

Build
----------------
```
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cp ../example/os-hardening/playbook-os-hardening.yml ./ 

ansible-playbook -i inventory.yml playbook-os-hardening.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../README.md#inventoryyml-샘플)

- [playbook-os-hardening.yml 참고](../../example/os-hardening/playbook-os-hardening.yml)

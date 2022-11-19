# java 
Java Runtime 작업을 프로비저닝 합니다 

Build
----------------
```
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cp ../example/java/playbook-java.yml ./ 

ansible-playbook -i inventory.yml playbook-java.yml
```


Appendix
----------------
- [inventory.yml 템플릿 참고](../../README.md#inventoryyml-샘플)

- [playbook-java.yml 참고](../../example/java/playbook-java.yml)

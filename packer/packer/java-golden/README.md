# java Runtime golden AMI 

OS Golden AMI 이미지 기반으로 EKS AMI를 빌드 합니다 


Build
----------
- 먼저 환경 변수를 확인 하세요.
```shell
echo "AWS_PROFILE: $AWS_PROFILE, AWS_REGION: $AWS_REGION, AWS_OWNER: $AWS_OWNER"
```
- OS Golden AMI 이미지 기반으로 EKS AMI를 빌드 합니다 
```shell
# project 체크아웃
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook

cp ./example/java/playbook-java.yml  ./ansible/playbook-java.yml 

packer validate ./packer/java-golden/ubuntu/javagold.json

# ami 빌드 
packer build ./packer/java-golden/ubuntu/javagold.json
```

Appendix
----------

- [Packer build](./ubuntu/javagold.json) 참고 
- [Playbook](../../example/java/playbook-java.yml) 참고  

제약사항
----------
현재 이미지를 빌드 하기 위해서 Source AMI는 "OS-Golden AMI"를 설정 해야 합니다 \
"OS 하드닝" 적용 사항을 준수하여 AMI를 빌드 합니다

- [OS 하드닝 적용 사항](../os-hardening/README.md#os-하드닝-적용-내용)
#Docker-DX-Harbor

Ubuntu AMI 기본 이미지 기반으로  Harbor 도커 이미지를 Push 합니다


Build
----------
- 먼저 환경 변수를 확인 하세요.
```shell
# 환경 변수 설정 샘플
export AWS_PROFILE=dxterra
export AWS_REGION=ap-northeast-2
export AWS_OWNER=827519537363

echo "AWS_PROFILE: $AWS_PROFILE, AWS_REGION: $AWS_REGION, AWS_OWNER: $AWS_OWNER"
```
- ubuntu 기본 이미지 기반으로 Harbor 도커 이미지를 빌드 합니다.
```shell
# 환경 변수 확인
echo "AWS_PROFILE: $AWS_PROFILE, AWS_REGION: $AWS_REGION, AWS_OWNER: $AWS_OWNER"

# project 체크아웃
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook

cp ./example/docker-harbor/playbook-harbor-docker.yml ./ansible/

packer validate ./packer/docker-harbor/ubuntu/harbor-docker-build.json

# ami 빌드 
packer build ./packer/docker-harbor/ubuntu/harbor-docker-build.json
```

Appendix
----------

- [Packer build](./ubuntu/harbor-docker-build.json) 참고
- [Playbook](../../example/docker-harbor/playbook-harbor-docker.yml) 참고

제약사항
----------
None

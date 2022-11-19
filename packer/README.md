# packer-playbook
packer + ansible-playbook 을 통해 최적화된 AWS AMI 이미지를 생성 합니다.

## AWS 프로파일 설정
```bash
aws configure --profile dx

AWS Access Key ID [None]: *********
AWS Secret Access Key [None]: *******
Default region name [None]: ap-northeast-2
Default output format [None]: json
```

### AWS 환경 정보 구성

AWS_PROFILE 환경 변수 설정

```shell
export AWS_PROFILE=<your profile> 
export AWS_REGION=<aws region>
export AWS_OWNER=<aws account id>
```

AWS_PROFILE 설정 샘플
```shell
export AWS_PROFILE=dxterra
export AWS_REGION=ap-northeast-2
export AWS_OWNER=827519537363
```

## Playbook 프로비저닝 가이드

프로비저닝 대상 호스트를 인벤토리(inventory.yml)로 관리 대상 노드(host)를 구성 하고 확인 할 수 있습니다.


### inventory example

"{base_dir}/ansible/inventory.yml" 와 같이 인벤토리 파일을 작성 할 수 있습니다.

**inventory.yml 샘플**
```yaml
all:
  hosts:
    image.builder:
      ansible_ssh_host: 54.180.113.11
      ansible_ssh_port: 22
      ansible_ssh_user: ubuntu
      ansible_ssh_private_key_file: "~/.ssh/test-an2-t-keypair.pem"
```
* 프로비저닝 대상 호스트를 yaml 형식에 맞게 구성 가능 합니다. 위의 예제에서는 image.builder 라는 호스트를 정의 하였습니다.


#### 관리 대상 노드를 확인하는 명령어
```bash
ansible -i inventory.yml --list-hosts all
```


#### 관리 대상 노드의 Facts 정보 확인하는 명령어
Facts 정보를 기반으로 OS 종류 및 버전에 맞게 프로비저닝 할 수 있습니다.
```bash
ansible all -m ansible.builtin.setup -i inventory.yml
```

###  role 단위 프로비저닝
playbook 파일을 통해 role 단위로 프로비저닝을 실행하고 결과를 확인 할 수 있습니다.

"ansible-playbook" 을 실행하기 위해선 roles 들을 관리하고 있는 "ansible" 디렉토리에서 실행 되어야 합니다.

다음은 "playbook-aws-cli.yml" 플레이북을 실행 하는 예제 입니다.

```bash
cp example/aws-cli/playbook-aws-cli.yml ./ansible/ 

cd ansible

ansible-playbook -i inventory.yml playbook-aws-cli.yml
```

inventory.yml 파일은 기준으로 "image.builder" 호스트에 "aws-cli" role 을 프로비저닝 하게 됩니다.



## 빌드
Packer 빌드 파일을 기준으로 AMI 이미지를 빌드 합니다.

### OS Golden AMI 빌드 예시

- 먼저 환경 변수를 확인 하세요
```shell
echo "AWS_PROFILE: $AWS_PROFILE, AWS_REGION: $AWS_REGION, AWS_OWNER: $AWS_OWNER"
```

- AMI 이미지를 빌드 합니다.
```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook

cp example/os-hardening/playbook-os-hardening.yml ./ansible/ 


# packer 구성 정보 검증
packer validate ./packer/os-golden/ubuntu/build.json

# AMI 빌드
packer build ./packer/os-golden/ubuntu/build.json
```


## Packer 빌드 참고
[packer](./packer/) 와 [playbook](./example/) 샘플을 참고 하여 최적화된 OS 이미지 또는 Docker 이미지를 빌드 할 수 있습니다.

- [BASTION 이미지 빌드](./packer/bastion/README.md)
- [OS 골든 이미지 빌드](packer/os-hardening/README.md)
- [Java 골든 이미지 빌드](./packer/java-golden/README.md)
- [EKS Node 골든 이미지 빌드](./packer/eks-node/README.md)
- [EKS DxRedis 이미지 빌드](packer/eks-redis/README.md)
- [EKS DxGitlab 이미지 빌드](./packer/eks-gitlab/README.md)
- [EKS DxHarbor 이미지 빌드](./packer/eks-harbor/README.md)
- [EKS DxSonarqube 이미지 빌드](./packer/eks-sonarqube/README.md)
- [EKS DxSpinnaker 이미지 빌드](./packer/eks-spinnaker/README.md)
- [EKS DxNexus 이미지 빌드](./packer/eks-nexus/README.md)
- [EKS DxJava 이미지 빌드](./packer/eks-java/README.md)
- [EKS DxNginx 이미지 빌드](./packer/eks-nginx/README.md)

## Ansible Playbook Guide
[ansible-guide](./docs/ansible-guide.md) 를 참고 하세요.


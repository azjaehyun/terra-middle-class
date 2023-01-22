# 웹서버 클러스터 구성 예제 (상용 환경)

이 폴더는 [Terraform](https://www.terraform.io/)의 [EC2](https://aws.amazon.com/ec2/), 자동 스케일링 그룹([Auto Scaling](https://aws.amazon.com/autoscaling/))과 로드밸런서([ELB](https://aws.amazon.com/elasticloadbalancing/))를 통해 웹서버 클러스터를 생성하는 실습 예제를 포함하고 있으며 로드밸런서를 통해 80포트로 오는 `/` URL 요청에 대해 "Hello, World"에 대한 응답을 수행 합니다. 이 코드는 테라폼 모듈로 정의된 클러스터와 로드밸런서 [modules/services/webserver-cluster](../../../../../module-example/modules/services/webserver-cluster)를 포함 합니다.

자세한 내용은 *[테라폼 설치에서 운영까지](http://www.terraformupandrunning.com)* 서적의 "제4장, 테라폼 모듈"을 참고 하십시오.

## 사전 준비 사항

* [Terraform](https://www.terraform.io/)이 설치 되어 있어야 합니다. 
* [Amazon Web Services (AWS) account](http://aws.amazon.com/) 계정을 보유 하고 있어야 합니다.
* [data-stores/mysql](../../data-stores/mysql) 리소스가 구성 되어 있어야 합니다.
  
## 시작 하기

**이 실습은 실제 AWS 리소스를 생성합니다. 대부분 [AWS Free Tier](https://aws.amazon.com/free/)로 지원되는 범위안에서 자원을 생성하고 활용하나 사용자의 조건에 따라서 비용이 일부 발생 할 수도 있습니다. 비용 발생에 대한 부분에 대해서는 실습 제공자가 책임지지 않으며 비용에 주의하여 실습을 진행하십시오. [비용 알람](http://bit.ly/2Nryf1C)을 설정해놓는 것을 권장합니다.** 

[AWS 엑세스 키](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) 
를 환경 변수로 설정:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

`vars.tf` 파일 안에, [data-stores/mysql](../../data-stores/mysql)에서 구성한 S3 버킷 이름과 원격에 저장된 MySQL 데이터베이스 상태 파일 이름을 입력:

```hcl
variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
}
```

환경 구성 검토:

```
terraform plan
```

환경 구성(코드 배포):

```
terraform apply
```

환경 정리:

```
terraform destroy
```

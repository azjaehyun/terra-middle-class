# RDS를 통한 MySQL 구성 예제 (스테이징 환경)

이번 실습은 [Terraform](https://www.terraform.io/)모듈을 통해 [RDS](https://aws.amazon.com/rds/)의 MySQL 데이터베이스 엔진을 
구성 하는 실습 입니다.

자세한 내용은 *[테라폼 설치에서 운영까지](http://www.terraformupandrunning.com)* 서적의 "제4장, 테라폼 모듈" 참고 하십시오.

## 사전 준비 사항

* [Terraform](https://www.terraform.io/)이 설치 되어 있어야 합니다. 
* [Amazon Web Services (AWS) account](http://aws.amazon.com/) 계정을 보유 하고 있어야 합니다.

## 시작 하기

**이 실습은 실제 AWS 리소스를 생성합니다. 대부분 [AWS Free Tier](https://aws.amazon.com/free/)로 지원되는 범위안에서 자원을 생성하고 활용하나 사용자의 조건에 따라서 비용이 일부 발생 할 수도 있습니다. 비용 발생에 대한 부분에 대해서는 실습 제공자가 책임지지 않으며 비용에 주의하여 실습을 진행하십시오. [비용 알람](http://bit.ly/2Nryf1C)을 설정해놓는 것을 권장합니다.** 

[AWS 엑세스 키](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) 
를 환경 변수로 설정:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

[S3](https://aws.amazon.com/s3/)에 [원격 상태](https://www.terraform.io/docs/state/remote.html)를 저장하기 때문에 
main.tf 파일에 [기존에 생성한 버킷](https://github.com/stitchlabio/terraform-up-and-running-code/tree/master/code/terraform/03-terraform-state/file-layout-example/global/s3)으로 변경이 필요하며 상태 파일 잠금까지 함께 실습하고자 할 경우 dynamodb_table도 함께 변경: 

```
terraform {
  backend "s3" {
    bucket = "(생성한 버킷 이름)"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
#    dynamodb_table = "(생성한 DynamoDB 테이블 이름)"
  }
}
```

환경 갱신(백엔드 구성을 위함):

```
terraform init
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

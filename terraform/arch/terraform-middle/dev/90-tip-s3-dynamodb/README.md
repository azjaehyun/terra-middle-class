### [terraform backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3)

### 학습 이유
~~~
- tfstate 파일에는 테라폼의 버전과 각 리소스에 대한 정보가 들어있습니다.
- 여기서 tfstate 파일을 관리하기에 앞서, Terraform Backend를 이해할 필요가 있습니다.
- Terraform Backend는 tfstate 파일을 어디에 저장하고 가져올지에 대한 설정을 의미합니다.
- 기본적으로 로컬에 저장이 되지만, 경우에 따라 S3 등 다양한 Backend Type을 설정할 수 있습니다.
- 여기서 단순히 S3에만 저장을 하는 것이 아니라 tfstate를 S3에 관리하면서 동시에 작업이 일어나지 않도록 DynamoDB에서 Lock 테이블을 생성해서 관리를 합니다.


~~~

### 적용방법 - provider.tf에 backend s3 적용!
~~~ 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend s3 {
    bucket         = "jaehyun-terraform-tfstate" # S3 버킷 이름
    key            = "terraform/terraform.tfstate" # s3 해당위치에 tfstate 저장 경로
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-tfstate-lock" # dynamodb table 이름
  }
}

provider "aws" {
  region = "ap-northeast-2"
}
~~~


## 동시에 작업 진행시.
~~~
>> 먼저 실행한 사람이 lock을 걸고 작업 진행.
aws_instance.example: Destroying... [id=i-0536a7d2bfc831293]
aws_instance.example: Still destroying... [id=i-0536a7d2bfc831293, 10s elapsed]
aws_instance.example: Still destroying... [id=i-0536a7d2bfc831293, 20s elapsed]
aws_instance.example: Still destroying... [id=i-0536a7d2bfc831293, 30s elapsed]
aws_instance.example: Still destroying... [id=i-0536a7d2bfc831293, 40s elapsed]
aws_instance.example: Destruction complete after 40s

-------------------------------------------------------------------------------
>> 하지만 다른 유저가 실행시키게 되면 아래와 같은 에러 발생.
Error: Error locking state: Error acquiring the state lock: ConditionalCheckFailedException: The conditional request failed
Lock Info:
  ID:        ca5d708a-ec0f-232c-0bcf-6f18f674dea1
  Path:      jaehyun-terraform-tfstate/terraform/terraform.tfstate
  Operation: OperationTypeApply
  Who:       jaehyun@imsiileum-ui-MacBookPro.local
  Version:   0.14.10
  Created:   2023-01-23 15:21:50.193731 +0000 UTC
  Info:


Terraform acquires a state lock to protect the state from being written
by multiple users at the same time. Please resolve the issue above and try
again. For most commands, you can disable locking with the "-lock=false"
flag, but this is not recommended.

~~~

##lock 제거
```
ps aux | grep terraform
kill -9 {process id}
```
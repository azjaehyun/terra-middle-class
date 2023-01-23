### [terraform backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3)

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
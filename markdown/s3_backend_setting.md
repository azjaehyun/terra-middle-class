
terraform status FILE s3 연동 p72  
============

#### terraform backend 설정 
#### 상태 파일을 공유하거나 백업 용도로 사용한다. ( 버전 관리 용이 )
>
>terraform.tfstate는 Locally 하게 저장된 것이지만 Terraform Backend 는 Terraform의 state file을 어디에 저장을 하고, 가져올지에 대한 설정이다. 
>
--------

1. s3 생성 및 dynamodb 생성
----------
~~~
provider "aws" {
  region = "ap-northeast-2" # Please use the default region ID
  version = "~> 2.49.0" # Please choose any version or delete this line if you want the latest version
}

# S3 bucket for backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "tfstate_bucket"

  versioning {
    enabled = true # Prevent from deleting tfstate file
  }
}

# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
~~~

2. backend 설정
----------
~~~
#backend.tf

terraform {
    backend "s3" { # terraform backend type이 s3라고 명시
      bucket         = "tfstate_bucket" # s3 bucket 이름
      key            = "terraform/own-your-path/terraform.tfstate" # s3 내에서 저장되는 경로를 의미합니다.
      region         = "ap-northeast-2"  
      encrypt        = true
      dynamodb_table = "terraform-lock" # DynamoDB 이름
    }
}
~~~

참고자료
>
>https://libertegrace.tistory.com/entry/IaCTerraform-Terraform-Backend-%ED%99%9C%EC%9A%A9%ED%95%98%EA%B8%B0
>
>https://blog.outsider.ne.kr/1290
~~~

## Terraform 중급반
### 목표 ( 테라폼 변수 및 변수 활용 , 모듈 만들기 , 테라폼 eks 생성 및 활용 )
---
## Section 1 .

** terraform 알아가기. 
* 테라폼 환경 셋팅
   - cloud9 생성  
* 테라폼 기본 명령어 실습
   
   - terraform cli 명령어 실습
   - terraform 기본 파일 설명 
      - data.tf / main.tf / output.tf / variable.tf 등등...
* 테라폼 Variable Type & Expression 실습
   - Variable Type
   - Expression
   - Terraform fuction
* 테라폼 모듈 만들기.
   - terraform module 구조 
   - terraform module 생성
   - terraform module 폴더 구성
   - terraform module 실습
* 테라폼 모듈을 활용한 aws infra 만들어보기. ( 실습 )
   - 워밍업 샘플.
   - arch 1 // public subnet 환경에 ec2 web , ec2 was 생성 
   - arch 2 // ec2 web , alb <-> ec2 연동
   - arch 3 // eks 실습을 위한 ec2 bastion 서버 구성하기. ( Section.2 사전 준비 )
----

## Section 2.
** eks 환경 실습
 - terraform eks cluster 생성 및 nodegroup 생성
 - terraform istio 설치. 
 - route53 -> istio -> ingress -> virtual service ->  DestinationRule -> service -> deployment -> pod 실습.
---
## Section 3. ( 부록 ) - 시간이 가능하면 진행.
** 부록 ( 팀 단위 개발시 필요한 기능 )
- terraform status 파일 s3 업로드.
- terraform dynamodb 연동 ( back )


-----
** module template 만들기
* infra architecture 코드 제작 //  
* route53 , domain ssl , s3
* eks 설치 
* aws ALB 생성 , Ingress ssl 연동 , k8s service & pod 생성
```
terraform init
terraform plan
terraform apply
```

### terraform document
~~~
https://registry.terraform.io/providers/hashicorp/aws/latest/docs
~~~

-----


### 1. MFA 토큰을 사용하여 AWS CLI 인증 설정
```
https://aws.amazon.com/ko/premiumsupport/knowledge-center/authenticate-mfa-cli/
```

-----



### variable type
https://www.terraform.io/language/expressions/types



-----

### Expression - https://www.terraform.io/language/expressions
```
for https://honglab.tistory.com/216
```


<a href="https://github.com/azjaehyun"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fazjaehyun&count_bg=%23000000&title_bg=%23000000&icon=github.svg&icon_color=%23E7E7E7&title=GitHub&edge_flat=false)"/></a>

terraform middle class
============

## Terraform ( Variable & Expression & Module & EKS )
- ### 목표 ( 테라폼 변수 및 변수 활용 , 모듈 만들기 , 테라폼 eks 생성 및 활용 )
---

## 강의 커리큘럼
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
  - terraform module 폴더 구성
  - terraform module 만들기
  - terraform module 실습
* 테라폼 모듈을 활용한 aws infra 만들어보기. ( 실습 )
  - 워밍업 샘플.
  - arch 1 // public subnet 환경에 ec2 docker 기반 web , was 생성 
  - arch 2 // public subnet 환경에 ec2 docker 기반 web 생성 후 ALB <-> ec2 연동
  - arch 3 // eks 실습을 위한 ec2 bastion 서버 구성하기. ( Section.2 사전 준비 )

## Section 2.
** eks 환경 실습
  - terraform eks cluster 생성 및 nodegroup 생성
  - terraform istio 설치. 
  - route53 -> istio -> ingress -> virtual service -> DestinationRule -> service -> deployment -> pod 실습.
---

## Section 3. ( 부록 ) - 시간이 가능하면 진행.
** 부록 ( 팀 단위 개발시 필요한 기능 )
  - terraform status 파일 s3 업로드.
  - terraform dynamodb 연동 ( back )

---


## terraform.tfvars - variable date common 적용 tip

```
locals {
  name_prefix   = format("%s-%s%s", var.context.project, var.context.region_alias, var.context.env_alias)
  tags = {
    Project     = var.context.project
    Environment = var.context.environment
    Team        = var.context.team
    Owner       = var.context.owner
  }
  current_time = "${formatdate("YYYYMMDD", timestamp())}" # 기존 local 에 이 친구만 추가
}

main.tf에서 사용방법
module "aws_ec2_bastion" {
  source        = "../../../../modules/aws/ec2/ec2_bastion"
  sg_groups     = [module.aws_sg_default.sg_id]
  key_name      = module.aws_key_pair.key_name
  public_access = true
  subnet_id     = module.aws_public_subnet_a.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-ec2-public-bastion-a", local.name_prefix)}, {Date = local.current_time})
} # DATE Tag 추가
```
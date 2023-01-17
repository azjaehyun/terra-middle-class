## 사전 준비 사항
* aws cli install & terraform cli install
* aws configure 설정
```
aws configure // 본인의 AWS_ACCESS_KEY , AWS_SECRET_ACCESS_KEY 넣기.
aws configure list
// 위에 환경설정 경로는 해당경로에 있습니다 참고! cd ~/.aws/credentials
```
* ### 환경변수로 default profile을 등록하여 준다.
```
$ export AWS_DEFAULT_PROFILE=terraformPrac
```
---
### [cloud9 생성](https://docs.aws.amazon.com/ko_kr/cloud9/latest/user-guide/tutorial-create-environment-cli-step1.html)
#### 주의사항
* --subnet-id argument는 public subnet 이여야 합니다.
* az는  ap-northeast-2a or ap-northeast-2c 여야 합니다. ap-northeast-2b는 생성시 오류
* --subnet-id 만 본인의 subnet id를 넣어주세요. 

vpc 조회
```
aws ec2 describe-vpcs // 모든 vpc 조회
aws ec2 describe-vpcs --filter 'Name=isDefault,Values=true' // default vpc 조회
```
결과
~~~
sh-3.2$ aws ec2 describe-vpcs --filter 'Name=isDefault,Values=true'
{
    "Vpcs": [
        {
            "CidrBlock": "172.31.0.0/16",
            "DhcpOptionsId": "dopt-02d10ef4c9f88f560",
            "State": "available",
            "VpcId": "vpc-02630b86af4d67bbf",
            "OwnerId": "767404772322",
            "InstanceTenancy": "default",
            "CidrBlockAssociationSet": [
                {
                    "AssociationId": "vpc-cidr-assoc-03d1c2e7b2df22eee",
                    "CidrBlock": "172.31.0.0/16",
                    "CidrBlockState": {
                        "State": "associated"
                    }
                }
            ],
            "IsDefault": true,
            "Tags": [
                {
                    "Key": "for-use-with-amazon-emr-managed-policies",
                    "Value": "true"
                }
            ]
        }
    ]
}
~~~

subnet 조회 

```
aws ec2 describe-subnets --filter 'Name=vpc-id,Values=vpc-0ba29b5a6c6ba9bb8' | jq '.Subnets[]'
결과   MapPublicIpOnLaunch // true가 public subnet
{
  "AvailabilityZone": "ap-northeast-2a",
  "AvailabilityZoneId": "apne2-az1",
  "AvailableIpAddressCount": 250,
  "CidrBlock": "20.20.1.0/24",
  "DefaultForAz": false,
  "MapPublicIpOnLaunch": false,
  "MapCustomerOwnedIpOnLaunch": false,
  "State": "available",

...

```

```
aws cloud9 create-environment-ec2 --name terraformPrac \
 --description "This environment is for the AWS Cloud9 terraformPrac." \
 --instance-type t2.micro --image-id resolve:ssm:/aws/service/cloud9/amis/ubuntu-18.04-x86_64 \
 --region ap-northeast-2 \
 --connection-type CONNECT_SSM \
 --subnet-id subnet-051809d7488bb2545  
```

명령어 실행후 정상적으로 생성되면 아래와 같은 결과값이 출력됩니다.
```
{
    "environmentId": "95595d60ef484fd1952b0d43b205d76f"
}
```
---
### cloud9 delete 
```
aws cloud9 delete-environment --environment-id=95595d60ef484fd1952b0d43b205d76f
> 다른 응답 결과는 없습니다.
```
---
### cloud9 다양한 argument
```
create-environment-ec2                   | create-environment-membership
delete-environment                       | delete-environment-membership
describe-environment-memberships         | describe-environment-status
describe-environments                    | list-environments
list-tags-for-resource                   | tag-resource
untag-resource                           | update-environment
update-environment-membership            | help
```
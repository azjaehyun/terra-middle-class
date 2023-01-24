## terraform variable.tf , data.tf , function 실습

## [Type and Values](https://developer.hashicorp.com/terraform/language/expressions/types)

## 1. Variable 
* ### 1-1. [String variable type](https://www.terraform.io/language/expressions/strings)
* terraform console 실행
```
> var.stringVal
> "stringVal"
> "Hello, ${var.stringVal}!"
"Hello, stringVal!"
```
* ### 1-2. String Directives [지시문]
```
> "Hello, %{ if var.stringVal != "" }${var.stringVal}%{ else }unnamed%{ endif }!"
"Hello, stringVal!"
> "Hello, %{ if var.stringValNull != "" }${var.stringValNull}%{ else }unnamed%{ endif }!"
"Hello, unnamed!"
``` 

* ### 1-3. [Variable validation](https://www.terraform.io/language/values/variables#custom-validation-rules)
```
variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^ami-", var.image_id))
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}
```

* ### 1-2. [List variable type](https://www.terraform.io/language/expressions/types)
```
$ echo 'split(",", "foo,bar,baz")' | terraform console
tolist([
  "foo",
  "bar",
  "baz",
])
> split(",", "foo,bar,baz")
tolist([
  "foo",
  "bar",
  "baz",
])
```

* ### 1-3. variable map type
```
resource "random_pet" "example" {
  for_each = var.regions
}
> var.regions.east
{
  "region" = "us-east-1"
}
```

## 2. Data 사용법 
```
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
```
* ### data.tf / [ec2 ami id search](https://cloud-images.ubuntu.com/locator/ec2/) 
```
terraform plan
data.aws_ami.ubuntu: Reading...
data.aws_ami.ubuntu: Read complete after 0s [id=ami-0b9954ae1a8f15194]

Changes to Outputs:
  + ec2_id = {
      + architecture          = "x86_64"
      + arn                   = "arn:aws:ec2:ap-northeast-2::image/ami-0b9954ae1a8f15194"
      + block_device_mappings = [
          + {
              + device_name  = "/dev/sda1"
              + ebs          = {
                  + "delete_on_termination" = "true"
                  + "encrypted"             = "false"
                  + "iops"                  = "0"
                  + "snapshot_id"           = "snap-015056e5a468469e0"
                  + "throughput"            = "0"
                  + "volume_size"           = "8"
                  + "volume_type"           = "gp2"
                }
              + no_device    = ""
              + virtual_name = ""
            },
```



## 3. [function 기능](https://www.terraform.io/language/functions)
- #### example cidrsubnets - https://www.terraform.io/language/functions/cidrsubnets
```
terraform console  
>cidrsubnets("10.1.0.0/16", 4, 4, 8, 4)  // 단일 서브넷 주소를 계산하여 네트워크 번호를 지정할 수 있습니다.
>tolist([
  "10.1.0.0/20",
  "10.1.16.0/20",
  "10.1.32.0/24",
  "10.1.48.0/20",
])
>cidrsubnets("10.1.0.0/16", 8, 8, 8, 8)
tolist([
  "10.1.0.0/24",
  "10.1.1.0/24",
  "10.1.2.0/24",
  "10.1.3.0/24",
])
>cidrsubnets("10.1.0.0/16", 8, 8)
tolist([
  "10.1.0.0/24",
  "10.1.1.0/24",
])
> cidrhost("10.12.112.0/20", 16) // 주어진 네트워크 주소 접두사 내에서 단일 호스트에 대한 IP 주소를 계산합니다.
10.12.112.16
```


### Guide Reference doc
```
https://www.terraform.io/language/expressions/types
https://www.terraform.io/cli/commands/console
```

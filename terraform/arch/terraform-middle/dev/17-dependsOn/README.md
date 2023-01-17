### https://www.terraform.io/cli/commands/console

## depends on 기능 이해 하기
- depends_on 의존성을 명시적으로 선언하는 데 사용할 수 있습니다. 또한 depends_on에 여러 리소스를 지정할 수 있으며 terraform은 대상 리소스를 만들기 전에 모든 리소스가 생성될 때까지 기다립니다.

- 단 지정된 리소스가 생성될 때까지 종속 리소스 생성을 기다리므로 명시적 종속성을 추가하면 terraform이 인프라를 생성하는 데 걸리는 시간이 늘어날 수 있습니다. (생성 순서가 중요할때 쓰기!)

- 구성 파일에서 리소스가 선언되는 순서는 terraform이 리소스를 생성하거나 삭제하는 순서에 영향을 미치지 않습니다.

~~~
resource "aws_s3_bucket" "my_s3" {
  bucket = "my_s3"
  acl    = "private"
}

resource "aws_instance" "my_ec2" {
  # ami           = "ami-2768hd97c"  // fix - ami 이름 ..
  ami = data.aws_ami.ubuntu.id  // data에서 값 가져오기.
  instance_type = "t2.micro"

  ## depends_on = [aws_s3_bucket.my_s3]
}
~~~

----

# Tip Zone!
## 1. s3 생성시 이름 존재 유무 확인 방법
- s3를 생성하기전에 s3의 이름이 있는지 먼저 확인해야 합니다. s3이름은 고유해야하기 때문에. 생성가능한지 확인후에 bucket 이름을 셋팅하는것을 추천 드립니다.
~~~
➜  17-dependsOn git:(main) ✗ aws s3api head-bucket --bucket dlrjsdjqtrpTwl 
>> An error occurred (404) when calling the HeadBucket operation: Not Found // 404 코드는 생성 가능.


➜  17-dependsOn git:(main) ✗ aws s3api head-bucket --bucket hello                      
>> An error occurred (403) when calling the HeadBucket operation: Forbidden // 403 코드는 이미 버킷 이름이 있기 때문에 생성 불가능!!
~~~~

## 2. ami id 조회 방법
- https://cloud-images.ubuntu.com/locator/ec2/


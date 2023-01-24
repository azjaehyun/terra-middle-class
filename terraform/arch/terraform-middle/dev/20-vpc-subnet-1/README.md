# 기초 arch 학습 terraform 실행방법
```
terraform init
terraform plan
terraform apply
```

## resource check
```

Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:

react_public_ip = "43.200.1.38"
springboot_public_ip = "43.201.52.18"
ssh_private_key_pem = <sensitive> 
ssh_public_key_pem = <sensitive>

curl http://{springboot_public_ip}:8080/hello
>> { "message": "hello "}
curl http://{react_public_ip}:3000
>> 
<!DOCTYPE html>
<html lang="en">
    <head>
    ... 생략 
    </body>
</html>
```
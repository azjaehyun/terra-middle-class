## terraform 기본 cli 명령어 
### 1. terraform init
```
terraform init
```

### 2. terraform plan
```
terraform plan
```
* 특정 리소스만 plan 보기
```
terraform plan -target={resourceName}
ex) terraform plan -target=module.aws_key_pair
```

### 3. terraform apply
```
terraform plan
```
* 특정 리소스만 apply
```
terraform apply -target={resourceName}
ex) terraform plan -target=module.aws_key_pair
```


### 4. terraform destroy
```
terraform destroy
```
* 특정 리소스만 destroy
```
terraform destroy -target={resourceName}
ex) terraform destroy -target=module.aws_key_pair
```

### 5. [debug & log.file](https://learn.hashicorp.com/tutorials/terraform/troubleshooting-workflow#bug-reporting-best-practices?utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS)
```
export TF_LOG_PROVIDER=TRACE  // debug
export TF_LOG_PATH=logs.txt // logfile 
```

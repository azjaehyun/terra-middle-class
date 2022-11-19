# docker-compose 를 통한 gitlab 컨테이너 실행 예시

Gitlab docker container 주의 사항
---------------
- AWS RDS Postgresql 엔진을 사용한다면 postgresql['enable'] 속성값은 반드시 false 로 설정 하세요. 
- gitlab_rails['auto_migrate'] 속성 값은 반드시 true 로 설정 해야 초기 스키마가 생성 됩니다.
- grafana 와 prometheus 는 EKS 에서 통합 관리한다면 false 로 설정 합니다.
- simple-initdb-an2t-aurora-2.cjavt1jo1rrr.ap-northeast-2.rds.amazonaws.com 와 같은 RDS 도메인 이름은 psql 에서 DNS 해석에 문제가 있습니다.  
  ip address 를 식별하여 기입하세요 (nslookup domain.name)
- external_url 은 외부 public 네트워크에서 접근할 수 있는 endpoint 를 기입 하세요. (login redirect 등의 기준 uri 정보입니다.) 


## Run

**docker-compose.yaml**

```shell
cat > ./docker-compose.yaml << EOF
gitlab:
  container_name: gitlab
  image: 'gitlab-ce:13.10.3-ce'
  restart: always
  hostname: 'ec2-13-209-4-97.ap-northeast-2.compute.amazonaws.com'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      # Gitlab basic configuration
      external_url 'http://ec2-13-209-4-97.ap-northeast-2.compute.amazonaws.com'
      gitlab_rails['time_zone'] = 'Asia/Seoul'
      gitlab_rails['lfs_enabled'] = true
      gitlab_rails['gitlab_shell_ssh_port'] = 20022
      # PostgreSQl database configuration
      postgresql['enable'] = false
      # Recommend value is 1/4 of total RAM, up to 14GB.
      # postgresql['shared_buffers'] = '2GB'
      gitlab_rails['auto_migrate'] = true
      gitlab_rails['db_adapter'] = 'postgresql'
      gitlab_rails['db_encoding'] = 'utf8'
      # nslookup simple-initdb-an2t-aurora-2.cjavt1jo1rrr.ap-northeast-2.rds.amazonaws.com
      gitlab_rails['db_host'] = '3.34.24.180'
      gitlab_rails['db_port'] = 5432
      gitlab_rails['db_database'] = 'gitlab_toolchain'
      gitlab_rails['db_username'] = 'gitlab'
      gitlab_rails['db_password'] = 'gitlab!234'
      # Monitoring & Dashboard
      grafana['enable'] = false
      prometheus['enable'] = false
  ports:
    - '80:80'
    - '443:443'
    - '20022:20022'
  volumes:
    # Mount EBS volume
    - '/data/gitlab/config:/etc/gitlab'
    - '/data/gitlab/logs:/var/log/gitlab'
    - '/data/gitlab/data:/var/opt/gitlab'
EOF


docker-compose -f docker-compose.yaml up -d
```

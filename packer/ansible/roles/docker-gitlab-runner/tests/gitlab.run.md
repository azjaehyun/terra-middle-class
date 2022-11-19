# Docker 엔진을 통한 gitlab 컨테이너 실행 예시

AWS RDS 와 같은 외부 데이터베이스를 사용하는 경우
---------------
- AWS RDS Postgresql 엔진을 사용한다면 postgresql['enable'] 속성값은 반드시 false 로 설정 하세요.
- gitlab_rails['auto_migrate'] 속성 값은 반드시 true 로 설정 해야 초기 스키마가 생성 됩니다.
- grafana 와 prometheus 는 EKS 에서 통합 관리한다면 false 로 설정 합니다.
- simple-initdb-an2t-aurora-2.cjavt1jo1rrr.ap-northeast-2.rds.amazonaws.com 와 같은 RDS 도메인 이름은 psql 에서 DNS 해석에 문제가 있습니다.  
  ip address 를 식별하여 기입하세요 (nslookup domain.name)
- external_url 은 외부 public 네트워크에서 접근할 수 있는 endpoint 를 기입 하세요. (login redirect 등의 기준 uri 정보입니다.)

## Run

```shell
export GITLAB_OMNIBUS_CONFIG="external_url 'http://ec2-13-209-4-97.ap-northeast-2.compute.amazonaws.com'"
GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}; grafana['enable'] = false"
GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}; prometheus['enable'] = false"
GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}; postgresql['enable'] = false"
GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}; gitlab_rails['auto_migrate'] = true"
GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}; gitlab_rails['db_adapter'] = 'postgresql'"
GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}; gitlab_rails['db_host'] = 'simple-initdb-an2t-aurora-2.cjavt1jo1rrr.ap-northeast-2.rds.amazonaws.com'"
GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}; gitlab_rails['db_database'] = 'gitlab_toolchain'"
GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}; gitlab_rails['db_username'] = 'gitlab'"
GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}; gitlab_rails['db_password'] = 'gitlab!234'"
GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}; gitlab_rails['db_encoding'] = 'utf8'"
GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}; gitlab_rails['gitlab_shell_ssh_port'] = 22022"

docker run --detach \
  --hostname=gitlab.devapp.shop \
  --restart always \
  --name gitlab \
  --env GITLAB_OMNIBUS_CONFIG="${GITLAB_OMNIBUS_CONFIG}" \
  --env GITLAB_TIMEZONE="Asia/Seoul" \
  --publish 443:443 \
  --publish 80:80 \
  --publish 22022:22022 \
  --volume /data/gitlab/config:/etc/gitlab \
  --volume /data/gitlab/logs:/var/log/gitlab \
  --volume /data/gitlab/data:/var/opt/gitlab \
  gitlab-ce:13.10.3-ce
```
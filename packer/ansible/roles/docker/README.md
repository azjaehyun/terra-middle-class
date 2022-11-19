Role Name
=========

docker 패키지를 설치 합니다

Role Variables
--------------

[defaults/main.yaml](./defaults/main.yml)
```yaml
docker_repo_url: "https://download.docker.com/linux"
docker_apt_gpg_key: "{{ docker_repo_url }}/{{ os_name }}/gpg"

# add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
docker_apt_repository: "deb [arch=amd64] {{ docker_repo_url }}/{{ os_name }} {{ ansible_distribution_release }} stable"
dockerce_version: "5:20.10.5~3-0~ubuntu-bionic"
dockercecli_version: "5:20.10.5~3-0~ubuntu-bionic"
containerdio_version: "1.4.4-1"
``` 

Dependencies
------------
None.

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-docker.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: docker
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-docker.yml
```


Precautions
----------------
CoreDNS 및 Docker Container 내부에서 DNS 쿼리에 대해 resolving 이슈가 존재 
- [DX-17 참고](https://issue.bespinglobal.com/browse/DX-17?focusedCommentId=64853&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-64853)


Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventoryyml-샘플)


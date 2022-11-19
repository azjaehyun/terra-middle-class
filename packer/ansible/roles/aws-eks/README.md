Role Name
=========

EKS 워커노드(EC2) 구성을 위한 패키지를 설치/설정 합니다.

Role Variables
--------------
[defaults/main.yaml](./defaults/main.yml)

```yaml
# kubectl-version https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
kubernetes_version: "1.19.6"
kubernetes_build_date: "2021-01-05"
# cni_plugin: https://github.com/containernetworking/plugins/tags
cni_plugin_version: "v0.8.6"
# docker-ce version: https://docs.docker.com/engine/install/ubuntu/
dockerce_version: "5:20.10.5~3-0~ubuntu-bionic"
dockercecli_version: "5:20.10.5~3-0~ubuntu-bionic"
containerdio_version: "1.4.4-1"      
disk_part: true
disk_part_target: default
```

Dependencies
------------
- nfs-common
- aws-iam-authenticator

Build
----------------

```shell
git clone https://github.com/bsp-dx/packer-playbook.git

cd packer-playbook/ansible

cat > ./playbook-aws-eks.yml << EOF
---
- name: Provisioning
  hosts: image.builder
  become: true
  vars_files:
    - "group_vars/defaults.yml"
  roles:
    - role: sudo
    - role: lsof
    - role: htop
    - role: aws-cli
    - role: aws-ssm-agent
    - role: os-hardening
    - role: ssh-hardening
    - role: aws-eks
      kubernetes_version: "1.19.6"
      kubernetes_build_date: "2021-01-05"
      cni_plugin_version: "v0.8.6"
      dockerce_version: "5:20.10.5~3-0~ubuntu-bionic"
      dockercecli_version: "5:20.10.5~3-0~ubuntu-bionic"
      containerdio_version: "1.4.4-1"      
      disk_part: true
      disk_part_target: "default"
    - role: cleansing
EOF

# ansible playbook 빌드 
ansible-playbook -i ./inventory.yml ./playbook-aws-eks.yml
```

Appendix
----------------
- [inventory.yml 템플릿 참고](../../../README.md#inventoryyml-샘플)
- [EKS AMI 프로젝트](https://github.com/awslabs/amazon-eks-ami)
- [EKS Optimized AMI](https://github.com/awsdocs/amazon-eks-user-guide/blob/master/doc_source/eks-optimized-ami.md) 
- [EKS Custom AMI](https://github.com/aws-samples/amazon-eks-custom-amis) - (현재 EKS 1.19 버전까지 지원이 가능)
- [Kubernetes Version](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)
- [amazon-vpc-cni-k8s](https://github.com/aws/amazon-vpc-cni-k8s)
- [Kubernetes CNI Plugin](https://github.com/containernetworking/plugins/tags)
- [docker-ce for ubuntu](https://docs.docker.com/engine/install/ubuntu/)

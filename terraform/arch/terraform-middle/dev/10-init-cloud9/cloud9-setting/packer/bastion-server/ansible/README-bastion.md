# ansible bastion 


## [packer document](https://developer.hashicorp.com/packer/tutorials/aws-get-started)

To build the bastion AMI:

```
ansible-playbook -i inventory.yml playbook-bastion.yml
```

packer build
```
packer validate ./build.json
packer build ./build.json
```
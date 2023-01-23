# Packer example

This folder shows an example [Packer](https://www.packer.io/) template that can be used to create an [Amazon Machine
Image (AMI)](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) of an Ubuntu server with Apache, PHP, and
a sample PHP app installed.

For more info, please see Chapter 1, "Why Terraform", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Packer](https://www.packer.io/) installed on your computer. 
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).

## Quick start

**Please note that this example will deploy real resources into your AWS account. We have made every effort to ensure 
all the resources qualify for the [AWS Free Tier](https://aws.amazon.com/free/), but we are not responsible for any
charges you may incur.** 

Configure your [AWS access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as 
environment variables:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

## packer ubuntu install
```
sudo apt  install packer
packer -version
>> 1.0.4
```

## packer mac install
```
brew install packer
packer -version
>> 1.0.4
```


## [packer document](https://developer.hashicorp.com/packer/tutorials/aws-get-started)

To build the AMI:

```
packer init .
packer validate .
packer build aws-php-web-ubuntu.pkr.hcl
packer build aws-bastion
```

### output
```
➜  cloud9-setting git:(main) ✗ packer build aws-ubuntu.pkr.hcl
learn-packer.amazon-ebs.ubuntu: output will be in this color.

==> learn-packer.amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> learn-packer.amazon-ebs.ubuntu: Prevalidating AMI Name: learn-packer-linux-aws
    learn-packer.amazon-ebs.ubuntu: Found Image ID: ami-0cb1d752d27600adb
    learn-packer.amazon-ebs.ubuntu: Found Subnet ID: subnet-05fc8140881267383
==> learn-packer.amazon-ebs.ubuntu: Using existing SSH private key
==> learn-packer.amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_63cd4d25-958e-f9e9-b9e1-2ced8b636e18
==> learn-packer.amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> learn-packer.amazon-ebs.ubuntu: Launching a source AWS instance...
    learn-packer.amazon-ebs.ubuntu: Instance ID: i-0e8d1621e7f16cf74

... 생략...

==> learn-packer.amazon-ebs.ubuntu: Stopping the source instance...
    learn-packer.amazon-ebs.ubuntu: Stopping instance
==> learn-packer.amazon-ebs.ubuntu: Waiting for the instance to stop...
==> learn-packer.amazon-ebs.ubuntu: Creating AMI learn-packer-linux-aws from instance i-0e8d1621e7f16cf74
    learn-packer.amazon-ebs.ubuntu: AMI: ami-0a9fcabae6378a428
==> learn-packer.amazon-ebs.ubuntu: Waiting for AMI to become ready...
==> learn-packer.amazon-ebs.ubuntu: Skipping Enable AMI deprecation...
==> learn-packer.amazon-ebs.ubuntu: Terminating the source AWS instance...
==> Wait completed after 3 minutes 42 seconds

==> Builds finished. The artifacts of successful builds are:
--> learn-packer.amazon-ebs.ubuntu: AMIs were created:
ap-northeast-2: ami-0a9fcabae6378a428  // 실습용 ami 생성완료!!
```
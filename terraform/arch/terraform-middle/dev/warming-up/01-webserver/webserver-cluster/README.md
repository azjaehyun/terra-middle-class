# Web Server Example

This folder contains example [Terraform](https://www.terraform.io/) templates that deploy a cluster of web servers 
(using [EC2](https://aws.amazon.com/ec2/) and [Auto Scaling](https://aws.amazon.com/autoscaling/)) and a load balancer
(using [ELB](https://aws.amazon.com/elasticloadbalancing/)) in an [Amazon Web Services (AWS) 
account](http://aws.amazon.com/). The load balancer listens on port 80 and returns the text "Hello, World" for the 
`/` URL.

For more info, please see Chapter 2, "Getting started with Terraform", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer. 
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

Validate the templates:

```
terraform plan
```

Deploy the code:

```
terraform apply
```

When the `apply` command completes, it will output the DNS name of the load balancer. To test the load balancer:

```
curl http://(elb_dns_name):8080/
```

Clean up when you're done:

```
terraform destroy
```

실행결과
~~~ 
data.aws_availability_zones.available: Reading...
data.aws_availability_zones.available: Read complete after 1s [id=us-east-1]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_autoscaling_group.example will be created
  + resource "aws_autoscaling_group" "example" {
      + arn                       = (known after apply)
      + availability_zones        = [
          + "us-east-1a",
          + "us-east-1c",
        ]
      + default_cooldown          = (known after apply)
      + desired_capacity          = (known after apply)
      + force_delete              = false
      + force_delete_warm_pool    = false
      + health_check_grace_period = 300
      + health_check_type         = "ELB"
      + id                        = (known after apply)
      + launch_configuration      = (known after apply)
      + load_balancers            = [
          + "terraform-asg-example",
        ]
      + max_size                  = 10
      + metrics_granularity       = "1Minute"
      + min_size                  = 2
      + name                      = (known after apply)
      + name_prefix               = (known after apply)
      + protect_from_scale_in     = false
      + service_linked_role_arn   = (known after apply)
      + vpc_zone_identifier       = (known after apply)
      + wait_for_capacity_timeout = "10m"

      + tag {
          + key                 = "Name"
          + propagate_at_launch = true
          + value               = "terraform-asg-example"
        }
    }

  # aws_elb.example will be created
  + resource "aws_elb" "example" {
      + arn                         = (known after apply)
      + availability_zones          = [
          + "us-east-1a",
          + "us-east-1c",
        ]
      + connection_draining         = false
      + connection_draining_timeout = 300
      + cross_zone_load_balancing   = true
      + desync_mitigation_mode      = "defensive"
      + dns_name                    = (known after apply)
      + id                          = (known after apply)
      + idle_timeout                = 60
      + instances                   = (known after apply)
      + internal                    = (known after apply)
      + name                        = "terraform-asg-example"
      + security_groups             = (known after apply)
      + source_security_group       = (known after apply)
      + source_security_group_id    = (known after apply)
      + subnets                     = (known after apply)
      + tags_all                    = (known after apply)
      + zone_id                     = (known after apply)

      + health_check {
          + healthy_threshold   = 2
          + interval            = 30
          + target              = "HTTP:8080/"
          + timeout             = 3
          + unhealthy_threshold = 2
        }

      + listener {
          + instance_port     = 8080
          + instance_protocol = "http"
          + lb_port           = 80
          + lb_protocol       = "http"
        }
    }

  # aws_launch_configuration.example will be created
  + resource "aws_launch_configuration" "example" {
      + arn                         = (known after apply)
      + associate_public_ip_address = (known after apply)
      + ebs_optimized               = (known after apply)
      + enable_monitoring           = true
      + id                          = (known after apply)
      + image_id                    = "ami-40d28157"
      + instance_type               = "t2.micro"
      + key_name                    = (known after apply)
      + name                        = (known after apply)
      + name_prefix                 = (known after apply)
      + security_groups             = (known after apply)
      + user_data                   = "4430fd6498339061effa6d27ccf341a1e94569d7"

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + no_device             = (known after apply)
          + snapshot_id           = (known after apply)
          + throughput            = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + throughput            = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_security_group.elb will be created
  + resource "aws_security_group" "elb" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
        ]
      + name                   = "terraform-example-elb"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # aws_security_group.instance will be created
  + resource "aws_security_group" "instance" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 8080
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8080
            },
        ]
      + name                   = "terraform-example-instance"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + elb_dns_name = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_security_group.elb: Creating...
aws_security_group.instance: Creating...
aws_security_group.instance: Creation complete after 4s [id=sg-0145f40470dc93d87]
aws_launch_configuration.example: Creating...
aws_security_group.elb: Creation complete after 4s [id=sg-0b1ab82e296f5e86e]
aws_elb.example: Creating...
aws_launch_configuration.example: Creation complete after 2s [id=terraform-20230114061846919200000001]
aws_elb.example: Creation complete after 6s [id=terraform-asg-example]
aws_autoscaling_group.example: Creating...
aws_autoscaling_group.example: Still creating... [11s elapsed]
aws_autoscaling_group.example: Still creating... [21s elapsed]
aws_autoscaling_group.example: Still creating... [31s elapsed]
aws_autoscaling_group.example: Still creating... [41s elapsed]
aws_autoscaling_group.example: Still creating... [51s elapsed]
aws_autoscaling_group.example: Still creating... [1m1s elapsed]
aws_autoscaling_group.example: Still creating... [1m11s elapsed]
aws_autoscaling_group.example: Still creating... [1m21s elapsed]
aws_autoscaling_group.example: Still creating... [1m31s elapsed]
aws_autoscaling_group.example: Creation complete after 1m39s [id=terraform-20230114061853502700000002]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

elb_dns_name = "terraform-asg-example-1357281581.us-east-1.elb.amazonaws.com"
~~~
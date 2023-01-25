context = {
    aws_credentials_file    = "$HOME/.aws/credentials"
    aws_profile             = "jaehyun.yang@bespinglobal.com"
    aws_region              = "ap-northeast-2"
    region_alias            = "an2"

    project                 = "vpcsubnet2"
    environment             = "prd"
    env_alias               = "p"
    owner                   = "jaehyun.yang@bespinglobal.com"
    team_name               = "Devops CNE Team"
    team                    = "CNE"
    generator_date          = "20220821"
    domain                  = "vpcsubnet2.prac.dev"
    pri_domain              = "vpcsubnet2.prac"
}

# vpc prefix ip
vpc_cidr = "30.30"
keypair_name = "terraPracVpcSubnet2"
ami_id = "ami-0d9635b7c218dbdc6"
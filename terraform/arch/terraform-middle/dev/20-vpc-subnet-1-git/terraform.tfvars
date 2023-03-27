context = {
    aws_credentials_file    = "$HOME/.aws/credentials"
    aws_profile             = "jaehyun.yang@bespinglobal.com"
    aws_region              = "ap-northeast-2"
    region_alias            = "an2"

    project                 = "tf-mdc-test"
    environment             = "prd"
    env_alias               = "p"
    owner                   = "jaehyun.yang@bespinglobal.com"
    team_name               = "Devops CNE Team"
    team                    = "CNE"
    generator_date          = "20220821"
    domain                  = "terraform.prac.dev"
    pri_domain              = "terraform.prac"
}

# vpc prefix ip
vpc_cidr = "50.50"
keypair_name = "tf-mdc-test-key"

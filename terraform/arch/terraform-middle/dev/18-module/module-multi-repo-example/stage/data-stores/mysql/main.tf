provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "example" {
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "example_database_stage"
  username            = "admin"
  password            = "${var.db_password}"
  skip_final_snapshot = true
}

terraform {
  backend "s3" {
    bucket = "(생성한 버킷 이름)"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
#    dynamodb_table = "(생성한 DynamoDB 테이블 이름)"
  }
}
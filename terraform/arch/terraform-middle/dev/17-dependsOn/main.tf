resource "aws_s3_bucket" "b" {
  bucket = "jaehyun-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "public-read-write"
}

resource "aws_instance" "my_ec2" {
  #ami           = "ami-2768hd97c"
  ami =  data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  ## depends_on = [aws_s3_bucket.b]
}
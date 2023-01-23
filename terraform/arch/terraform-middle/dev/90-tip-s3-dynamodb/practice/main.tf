resource "aws_instance" "example" {
  ami           = "ami-05dedea102c553570"
  instance_type = "t2.micro"
}

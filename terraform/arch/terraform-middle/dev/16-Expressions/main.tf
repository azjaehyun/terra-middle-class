
# if문 테스트  // 1 - true , 0 - false
resource "null_resource" "ifvalue" {
  count = var.ifvalue
}

# for문 테스트
resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name = element(var.user_names, count.index )
}


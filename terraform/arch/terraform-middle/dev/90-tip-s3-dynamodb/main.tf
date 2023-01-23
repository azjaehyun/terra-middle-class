resource "aws_s3_bucket" "test-tfstate" {
  bucket = "jaehyun-terraform-tfstate"
}

resource "aws_s3_bucket_versioning" "test-versioning" {
  bucket = aws_s3_bucket.test-tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-tfstate-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
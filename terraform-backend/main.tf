provider "aws" {
    region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "stefan-terraform-state001"
    key = "global/s3/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "stefan-terraform-locks"
    encrypt = true
    
  }
}

#Adding versioning. Every update to a file in the bucket will create a new version of it

resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.stefan-terraform-state.id
    versioning_configuration {
      status = "Enabled"
    }
}

#Using a server-side encryption for all data written on our S3 bucket.
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
    bucket = aws_s3_bucket.stefan-terraform-state.id

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

#Blocking all public access to the bucket

resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket = aws_s3_bucket.stefan-terraform-state.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

#Creating DynamoDB table for locking. For this I must create a table with a primary key "LockID"

resource "aws_dynamodb_table" "terraform_locks" {
    name = "stefan-terraform-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    
    attribute {
      name = "LockID"
      type = "S"
    }
}
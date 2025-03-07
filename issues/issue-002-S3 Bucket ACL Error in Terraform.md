# S3 Bucket ACL Error in Terraform


## Issue description

I was trying to create S3 bucket by terraform with versioning enabled by terraform
```
# Create an S3 bucket to store the Terraform state
resource "aws_s3_bucket" "state_bucket" {
  bucket = "alison-demo-terraform-state-bucket"
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.state_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket = aws_s3_bucket.state_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}
```

## Error messages
When trying to apply Terraform code with `aws_s3_bucket_acl`, I encountered the following error:
```
│ Error: creating S3 Bucket (alison-demo-terraform-state-bucket) ACL: operation error S3: PutBucketAcl, https response error StatusCode: 400, RequestID: 9TJ62B6JSE9XCBF5, HostID: V+T5EYFOigoHd4q4vtSwThWRIH8GYVgY3OV4g87646E2+TRS6rklkbzyOqGmcNXykBRXOaR/pAKJW72/FeRwIT6UOxuk7HkFXe9sX/GuKH0=, api error AccessControlListNotSupported: The bucket does not allow ACLs
```
![alt text](<issues-002-screenshot.png>)




## Root cause analysis
- it occurs because AWS has disabled ACLs for new S3 buckets by default unless explicitly enabled. Terraform **failed** because I tried using `aws_s3_bucket_acl` on a bucket without ACL support. see [doc](https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html) for reference.

- The default `object_ownership = "BucketOwnerEnforced"` **disables ACLs**.
- AWS **deprecated ACLs for new S3 buckets** unless `object_ownership = "ObjectWriter"` is set.
- Terraform **failed** because I tried using `aws_s3_bucket_acl` on a bucket without ACL support.

## Solutions tried
- Remove **aws_s3_bucket_acl** block cause I don't need it anyway. All S3 buckets are private by default and can be accessed only by users who are explicitly granted access.

## Final Resolution

Updated my Terraform code as

```
# Create an S3 bucket to store the Terraform state
resource "aws_s3_bucket" "state_bucket" {
  bucket = "alison-demo-terraform-state-bucket"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket = aws_s3_bucket.state_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}
```



## Key takeaway
- All S3 buckets are private by default and can be accessed only by users who are explicitly granted access
- Use S3 bucket policies for access control instead of ACLs.(best practice)
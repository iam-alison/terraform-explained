# issue-001-S3 Bucket Already Exists Error in Terraform

I was trying to create S3 bucket by terraform with versioning enabled by terraform

```
# Create an S3 bucket to store the Terraform state
resource "aws_s3_bucket" "state_bucket" {
  bucket = "terraform-state-eks"
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

## Error Message
```
Error: creating S3 Bucket (terraform-state-eks): operation error S3: CreateBucket, https response error StatusCode: 409, RequestID: 6N9PV4K6MHDDQGF4, HostID: f/z/1aTFEIOsYO9EdvQYYFaJd2fsESrsIGSq+nERfm2YObnXvRB06pP9BmOy+Nqq/j4EloSimTE=, BucketAlreadyExists: 
│ 
│   with aws_s3_bucket.state_bucket,
│   on main.tf line 6, in resource "aws_s3_bucket" "state_bucket":
│    6: resource "aws_s3_bucket" "state_bucket" {". my source code: "# Create an S3 bucket to store the Terraform state
resource "aws_s3_bucket" "state_bucket" {
  bucket = "terraform-state-eks
```


## Root Cause Analysis

- S3 bucket names must be globally unique across all AWS accounts.
- The bucket name "terraform-state-eks" is already taken by another AWS account (or was previously created in my own account).
- My Terraform script does not check if the bucket already exists before trying to create it.


## Solutions Tried
1. Checked if the bucket already exists in my AWS account globally:
   ```
   aws s3api head-bucket --bucket your-bucket-name
   ```
  - If it exists:An error occurred (403) when calling the HeadBucket operation: Forbidden
  - If it doesn't exists: An error occurred (404) when calling the HeadBucket operation: Not Found
  - see [here](https://docs.aws.amazon.com/cli/latest/reference/s3api/head-bucket.html) for more info about head-bucket 
2. Updated the Terraform code to use a unique bucket name by adding a random suffix. (or add unique prefix can also fix it):

```
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "terraform-state-eks-${random_string.suffix.result}"
}
```

## Final Resolution

```
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "terraform-state-eks-${random_string.suffix.result}"
  object_ownership = "BucketOwnerEnforced"  # Disables ACLs
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
```

## Key Takeaways

- S3 bucket names must be globally unique.
Avoid hardcoding bucket names. Use [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) to ensure uniqueness.
or
- check if bucket exists before apply terraform by running `aws s3api head-bucket --bucket your-bucket-name`





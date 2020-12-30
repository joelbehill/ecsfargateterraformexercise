
# I don't feel comfortable adding this dynamodb which contains the terraform lock to terraform...
# in case I make a mistake.
/*
resource "aws_s3_bucket" "terraform_lock" {
  bucket = "hill-cc-terraform-state"
  versioning {
      enabled = true
  }
  server_side_encryption_configuration {
      rule {
          apply_server_side_encryption_by_default {
              sse_algorithm = "AES256"
          }
      }
  }
  object_lock_configuration {
      object_lock_enabled = "Enabled"
  }

  tags = merge(
    var.default_tags,
    {
      Name = "S3 Remote Terraform State Store"
    },
  )
}
*/

# I am not turning on cloudtrail in order to keep the costs down.  This would need to be enabled for HIPAA compliance.

/*
resource "aws_cloudtrail" "cloudtrail" {
  name                          = "hill-cc-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "hill-cc-cloudtrail"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::tf-test-trail"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::tf-test-trail/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
*/
resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3 bucket encryption"
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "guardduty.amazonaws.com"
        },
        "Action": [
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:ReEncrypt*"
        ],
        "Resource": "*",
        # "Condition": {
        #   "ForAnyValue:StringLike": {
        #     "aws:PrincipalOrgPaths": "o-4hvri**jx2/r-tc**/*"
        #   }
        # }
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "guardduty.amazonaws.com"
        },
        "Action": [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:ReEncrypt*"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/s3-bucket-key"
  target_key_id = aws_kms_key.s3_key.id
}
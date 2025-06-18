output "bucket_arm" {
  description = "use for GuardDuty Findings export configuration"
  value = aws_s3_bucket.bucket.arn
}

output "kms_key_arn" {
  description = "use for GuardDuty Findings export configuration"
  value = aws_kms_key.s3_key.arn
}
resource "aws_iam_user" "sqs_consumer" {
  name = "sqs-consumer-user"
}

resource "aws_iam_policy" "sqs_consume_policy" {
  name        = "SQSConsumePolicy"
  description = "Allows consuming messages from an SQS queue"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ListQueues"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ChangeMessageVisibility",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage"
        ]
        Resource = aws_sqs_queue.queue.arn
      },
      {
        "Action": [
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        "Resource": [
          aws_kms_key.s3_key.arn
        ],
        "Effect": "Allow"
      },
      {
        "Action": [
          "s3:GetBucket*",
          "s3:GetObject*",
          "s3:List*"
        ],
        "Resource": [
          aws_s3_bucket.bucket.arn, "${aws_s3_bucket.bucket.arn}/*"
        ],
        "Effect": "Allow"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_sqs_consume" {
  user       = aws_iam_user.sqs_consumer.name
  policy_arn = aws_iam_policy.sqs_consume_policy.arn
}

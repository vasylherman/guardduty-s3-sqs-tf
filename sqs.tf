data "aws_iam_policy_document" "queue" {
  statement {
    effect = "Allow"

    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:SendMessage"
    ]
    resources = ["arn:aws:sqs:*:*:s3-event-notification-queue"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [aws_s3_bucket.bucket.arn]
    }
  }
}

resource "aws_sqs_queue" "queue" {
  name   = "s3-event-notification-queue"
  policy = data.aws_iam_policy_document.queue.json
  visibility_timeout_seconds = 300
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue.arn
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue" "dead_letter_queue" {
  name = "dlq-for-s3-event-notification-queue"
}



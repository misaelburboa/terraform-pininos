data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "index.mjs"
  output_path = "lambda_function_payload.zip"
}


resource "aws_lambda_function" "sqs-message-handler" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "sqs-message-handler"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime = "nodejs20.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

#####

resource "aws_iam_role_policy_attachment" "lambda_sqs_role_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}


resource "aws_lambda_event_source_mapping" "sqs-event-source" {
  event_source_arn = aws_sqs_queue.test-messages-queue.arn
  function_name    = aws_lambda_function.sqs-message-handler.arn
}

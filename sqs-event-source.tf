# resource "aws_lambda_event_source_mapping" "sqs-event-source" {
#   event_source_arn = aws_sqs_queue.cvs-3797-example-queue.arn
#   function_name    = aws_lambda_function.cvs-3797-lambda.arn
# }

resource "aws_api_gateway_rest_api" "quotes" {
  name = "Quotes API"
  body = templatefile("./openapi.json",
    {
      quote_receiver = "${aws_lambda_function.quote_receiver.invoke_arn}",
      quote_recover  = "${aws_lambda_function.quote_recover.invoke_arn}"
    }
  )
}

resource "aws_api_gateway_deployment" "quotes" {
  rest_api_id = aws_api_gateway_rest_api.quotes.id
}

resource "aws_api_gateway_stage" "quotes" {
  deployment_id = aws_api_gateway_deployment.quotes.id
  rest_api_id   = aws_api_gateway_rest_api.quotes.id
  stage_name    = "dev"
}

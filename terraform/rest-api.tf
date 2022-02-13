# Declarando nossa api para acesso de frases e os métodos
resource "aws_api_gateway_rest_api" "quotes" {
  name        = "Quotes"
  description = "Api para consumo e envio de frases para a aplicação."
}

resource "aws_api_gateway_resource" "quotes" {
  rest_api_id = aws_api_gateway_rest_api.quotes.id
  parent_id   = aws_api_gateway_rest_api.quotes.root_resource_id
  path_part   = "quotes"
}

resource "aws_api_gateway_method" "get_quotes" {
  rest_api_id   = aws_api_gateway_rest_api.quotes.id
  resource_id   = aws_api_gateway_resource.quotes.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_quote" {
  rest_api_id   = aws_api_gateway_rest_api.quotes.id
  resource_id   = aws_api_gateway_resource.quotes.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "quote_receiver" {
  rest_api_id             = aws_api_gateway_rest_api.quotes.id
  resource_id             = aws_api_gateway_resource.quotes.id
  http_method             = aws_api_gateway_method.post_quote.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.quote_receiver.invoke_arn
}

resource "aws_api_gateway_deployment" "quotes" {
  depends_on = [
    aws_api_gateway_integration.quote_receiver,
  ]

  rest_api_id = aws_api_gateway_rest_api.quotes.id
  stage_name  = "dev"
}

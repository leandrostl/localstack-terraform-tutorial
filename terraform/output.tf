# Output do projeto
output "api_id" {
  value = aws_api_gateway_rest_api.quotes.id
}

output "resource_id" {
  value = aws_api_gateway_resource.quotes.id
}

output "queue_url" {
  value = aws_sqs_queue.quotes.url
}

output "base_url" {
  value = "${var.defaut_endpoint}/restapis/${aws_api_gateway_rest_api.quotes.id}/${aws_api_gateway_deployment.quotes.stage_name}/_user_request_/${aws_api_gateway_resource.quotes.path_part}"
}

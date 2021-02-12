output "id" {
  value = aws_api_gateway_rest_api.default.id
}

output "stage_name" {
  value = terraform.workspace
}

output "name" {
  value = var.name
}

output "invoke_url" {
  value = aws_api_gateway_deployment.lambda_gateway.invoke_url
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api.default.root_resource_id
}

output "path_id" {
  value = aws_api_gateway_resource.proxy_resource.id
}


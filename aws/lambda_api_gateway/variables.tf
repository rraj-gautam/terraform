variable "name" {
  description = "The name of the service. This will be used as the base_path (eg /$${name}/$${path_part}"
}

variable "path_part" {
  description = "By default, the Lambda needs a path part for the API Gateway uses a Lambda Proxy"
  default     = "{proxy+}"
}

variable "lambda_name" {
}

variable "lambda_arn" {
}

variable "lambda_invoke_arn" {
}

variable "lambda_role_name" {
}

variable "authorization" {
  default = "NONE"
}

variable "authorizer_id" {
  default = ""
}

variable "api_key_required" {
  default = false
}

variable "endpoint_type" {
  default = "EDGE"
}

variable "gateway_policy" {
  default = ""
}

variable "owner" {}

variable "stack" {}

variable "datadog_lambda_name" {}

variable "datadog_lambda_arn" {}

variable "enable_cache" {
    default = false
}

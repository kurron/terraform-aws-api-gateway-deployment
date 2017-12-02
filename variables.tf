variable "region" {
    type = "string"
    description = "The AWS region to deploy into (e.g. us-east-1)"
}

variable "api_gateway_id" {
    type = "string"
    description = "ID of the API Gateway, e.g. f6wayvdtd1"
}

variable "parent_resource_id" {
    type = "string"
    description = "ID of the root resource, e.g. rx3pwr22hf"
}

variable "parent_method_http_method" {
    type = "string"
    description = "The parent method's HTTP method, e.g. GET."
}

variable "target_url" {
    type = "string"
    description = "URL to proxy requests to, e.g. http://httpbin.org"
}

variable "child_resource_id" {
    type = "string"
    description = "The child resource's identifier, e.g. rx3pwr22hf"
}

variable "child_method_http_method" {
    type = "string"
    description = "The child method's HTTP method, e.g. GET."
}

variable "stage_name" {
    type = "string"
    description = "Current place in the API's lifecycle, e.g. production"
}

variable "stage_description" {
    type = "string"
    description = "Short description of the stage, e.g. API released for public consumption"
}

variable "deployment_description" {
    type = "string"
    description = "Short description of the first deployment, e.g. initial cut of the API"
}

variable "metrics_enabled" {
    type = "string"
    description = "Specifies whether Amazon CloudWatch metrics are enabled for this method."
}

variable "logging_level" {
    type = "string"
    description = "Specifies the logging level for this method, which effects the log entries pushed to Amazon CloudWatch Logs. The available levels are OFF, ERROR, and INFO."
}

variable "data_trace_enabled" {
    type = "string"
    description = "Specifies whether data trace logging is enabled for this method, which effects the log entries pushed to Amazon CloudWatch Logs."
}

variable "throttling_burst_limit" {
    type = "string"
    description = "Specifies the throttling burst limit."
}

variable "throttling_rate_limit" {
    type = "string"
    description = "Specifies the throttling rate limit."
}

variable "domain_name" {
    type = "string"
    description = "Domain name used when establishing the API Gateway, e.g. debug.transparent.engineering"
}

variable "base_path" {
    type = "string"
    description = "Path segment that must be prepended to the path when accessing the API via this mapping, e.g. /development"
}

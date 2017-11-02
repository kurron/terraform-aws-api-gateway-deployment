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

variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region for all resources."
  type        = string
}

variable "humble_environment" {
  default     = "release"
  description = "The name of the environment"
  type        = string
}

variable "humble_version" {
  default     = "1.0.0"
  description = "The version of the app"
  type        = string
}

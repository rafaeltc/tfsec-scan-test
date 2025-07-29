variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "my-example-bucket-12345"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "exampledb"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "password123"  # Security issue: hardcoded password
  sensitive   = true
}
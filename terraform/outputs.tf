output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.example.bucket
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web.id
}

output "database_endpoint" {
  description = "Database endpoint"
  value       = aws_db_instance.example.endpoint
  sensitive   = true
}
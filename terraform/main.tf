# This file intentionally contains security issues for testing

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Security Issue: S3 bucket without encryption
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  
  tags = {
    Name        = "Example bucket"
    Environment = var.environment
  }
}

# Security Issue: S3 bucket with public read access
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false  # Should be true
  block_public_policy     = false  # Should be true
  ignore_public_acls      = false  # Should be true
  restrict_public_buckets = false  # Should be true
}

# Security Issue: Security group with overly permissive rules
resource "aws_security_group" "web" {
  name_prefix = "web-sg"
  description = "Security group for web servers"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Too permissive
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Should be restricted
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security-group"
  }
}

# Security Issue: RDS instance without encryption
resource "aws_db_instance" "example" {
  identifier = "example-db"
  
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  
  allocated_storage = 20
  storage_encrypted = false  # Should be true
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password  # Should use manage_master_user_password
  
  skip_final_snapshot = true
  
  tags = {
    Name = "example-database"
  }
}

# Security Issue: IAM policy with wildcard permissions
resource "aws_iam_policy" "example" {
  name        = "example-policy"
  description = "Example IAM policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*"  # Too permissive - should be specific actions
        ]
        Effect   = "Allow"
        Resource = "*"  # Too permissive - should be specific resources
      },
    ]
  })
}
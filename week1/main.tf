# -----------------------------------------------------------------------------
# Week 1 — Deploying Your First Compliant Cloud Resource
# Controls Implemented: SC-28, AC-3, CM-6, AU-3/AU-6
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.6"

  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project         = var.project_name
      Environment     = var.environment
      ManagedBy       = "terraform"
      ComplianceScope = "SC-28 AC-3 CM-6 AU-3"
    }
  }
}

# -----------------------------------------------------------------------------
# Randomized suffix for globally-unique bucket names
# -----------------------------------------------------------------------------

resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  primary_name = lower("${var.project_name}-${var.environment}-data-${random_id.suffix.hex}")
  log_name     = lower("${var.project_name}-${var.environment}-logs-${random_id.suffix.hex}")
}

# -----------------------------------------------------------------------------
# Base S3 Buckets
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "primary" {
  bucket = local.primary_name
}

resource "aws_s3_bucket" "log" {
  bucket = local.log_name
}

# -----------------------------------------------------------------------------
# SC-28 — Encryption at Rest
# -----------------------------------------------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "primary" {
  bucket = aws_s3_bucket.primary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AWS:KMS"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log" {
  bucket = aws_s3_bucket.log.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# -----------------------------------------------------------------------------
# CM-6 — Versioning
# -----------------------------------------------------------------------------

resource "aws_s3_bucket_versioning" "primary" {
  bucket = aws_s3_bucket.primary.id

  versioning_configuration {
    status = "Enabled"
  }
}

# -----------------------------------------------------------------------------
# AC-3 — Block Public Access
# -----------------------------------------------------------------------------

resource "aws_s3_bucket_public_access_block" "primary" {
  bucket = aws_s3_bucket.primary.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "log" {
  bucket = aws_s3_bucket.log.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# -----------------------------------------------------------------------------
# AU-3 / AU-6 — Access Logging
# -----------------------------------------------------------------------------

# Ownership controls must be applied before ACL
resource "aws_s3_bucket_ownership_controls" "log" {
  bucket = aws_s3_bucket.log.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log" {
  bucket = aws_s3_bucket.log.id
  acl    = "log-delivery-write"

  depends_on = [
    aws_s3_bucket_ownership_controls.log
  ]
}

resource "aws_s3_bucket_logging" "primary" {
  bucket        = aws_s3_bucket.primary.id
  target_bucket = aws_s3_bucket.log.id
  target_prefix = "access-logs/"

  depends_on = [
    aws_s3_bucket_acl.log
  ]
}

# -----------------------------------------------------------------------------
# Evidence Outputs (Self‑Attesting Controls)
# -----------------------------------------------------------------------------

#output "primary_bucket_name" {
#  description = "Name of the primary data bucket."
#  value       = aws_s3_bucket.primary.bucket
#}

output "log_bucket_name" {
  description = "Name of the log bucket receiving access logs."
  value       = aws_s3_bucket.log.bucket
}

# SC-28: Encryption algorithm for the primary bucket
output "primary_bucket_encryption" {
  description = "SSE algorithm applied to the primary bucket (SC-28)."
  value = try(
    aws_s3_bucket_server_side_encryption_configuration.primary.rule[*].apply_server_side_encryption_by_default[*].sse_algorithm,
    "no-encryption-config"
  )
}

# SC-28: Encryption algorithm for the log bucket
output "log_bucket_encryption" {
  description = "SSE algorithm applied to the log bucket (SC-28)."
  value = try(
    aws_s3_bucket_server_side_encryption_configuration.log.rule[*].apply_server_side_encryption_by_default[*].sse_algorithm,
    "no-encryption-config"
  )
}

# CM-6: Versioning status
output "primary_bucket_versioning" {
  description = "Versioning status of the primary bucket (CM-6)."
  value       = try(aws_s3_bucket_versioning.primary.versioning_configuration[*].status, "unknown")
}

# AC-3: Public access block settings
output "primary_bucket_public_access_block" {
  description = "Public access block configuration for the primary bucket (AC-3)."
  value       = aws_s3_bucket_public_access_block.primary
}

output "log_bucket_public_access_block" {
  description = "Public access block configuration for the log bucket (AC-3)."
  value       = aws_s3_bucket_public_access_block.log
}

# AU-3/AU-6: Logging target bucket
output "logging_target_bucket" {
  description = "Bucket receiving access logs (AU-3/AU-6)."
  value       = aws_s3_bucket_logging.primary.target_bucket
}

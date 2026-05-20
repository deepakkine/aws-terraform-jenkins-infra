
output "bucket_names" {
  value = [for bucket in aws_s3_bucket.example : bucket.bucket]
}

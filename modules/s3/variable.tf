variable "bucket_names" {
  description = "List of S3 bucket configurations"
  type        = map(object({
    bucket_name = string
  }))
}

variable "environment" {
  description = "environment for dev or prod"
  type        = string
}

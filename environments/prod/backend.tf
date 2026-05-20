terraform {
  backend "s3" {
    bucket         = "mybucket-backend-6721"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}

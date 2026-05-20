terraform {
  backend "s3" {
    bucket  = "deepakkine-terraform-state-bucket-2026"
    key     = "dev/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}

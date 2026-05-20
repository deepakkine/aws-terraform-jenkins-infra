module "ec2" {
  source = "../../modules/ec2"
  instances = {
    "dev-instance-1" = {
      ami_id        = "ami-0dee22c13ea7a9a67"
      instance_type = "t3.micro"
      name          = "dev-instance-1"
      subnet_id     = module.vpc.public_subnet_ids[0]
    }
  }
  environment = "dev"
}

module "s3" {
  source = "../../modules/s3"
  bucket_names = {
    "bucket1" = { bucket_name = "deepakkine-dev-demo-bucket-2026" }
  }
  environment = "dev"
}

module "vpc" {
  source               = "../../modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  vpc_name             = "deepakkine-dev-vpc"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  # private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["ap-south-1a", "ap-south-1b"]

  environment = "dev"
}
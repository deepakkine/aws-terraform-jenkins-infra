module "ec2" {
  source      = "../../modules/ec2"
  instances = {
  "prod-instance-1" = {
    ami_id        = "ami-0dee22c13ea7a9a67", 
    instance_type = "t2.micro", 
    name          = "prod-instance-1", 
    subnet_id     = module.vpc.public_subnet_ids[0]
  },
  "prod-instance-2" = {
    ami_id        = "ami-0dee22c13ea7a9a67", 
    instance_type = "t2.medium", 
    name          = "prod-instance-2", 
    subnet_id     = module.vpc.public_subnet_ids[1]
  },
  "prod-instance-3" = {
    ami_id        = "ami-0dee22c13ea7a9a67", 
    instance_type = "t2.micro", 
    name          = "prod-instance-3", 
    subnet_id     = module.vpc.private_subnet_ids[0]
  },
  "prod-instance-4" = {
    ami_id        = "ami-0dee22c13ea7a9a67", 
    instance_type = "t2.medium", 
    name          = "prod-instance-4", 
    subnet_id     = module.vpc.private_subnet_ids[1]
  }
}
  environment = "prod"
}



module "s3" {
  source      = "../../modules/s3"
  bucket_names = {
    "bucket1" = { bucket_name = "prod-demo-buck-6721" },
    "bucket2" = { bucket_name = "prod-demo-buck-1241" },
    "bucket3" = { bucket_name = "prod-demo-buck-9021" },
    "bucket4" = { bucket_name = "prod-demo-buck-294" }
  }
  environment = "prod"
}

module "vpc" {
  source                = "../../modules/vpc"
  vpc_cidr              = "10.0.0.0/16"
  vpc_name              = "my-vpc"
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones    = ["ap-south-1a", "ap-south-1b"]
  environment = "prod"
}
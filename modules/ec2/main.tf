resource "aws_instance" "example" {
  for_each = var.instances
  ami           = each.value.ami_id
  instance_type = each.value.instance_type
  subnet_id     = each.value.subnet_id
  tags = {
    Name        = each.value.name
    Environment = var.environment
  }
}



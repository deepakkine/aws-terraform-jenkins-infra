# Output VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Output Public Subnet IDs
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

# Output Private Subnet IDs
output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

# Output NAT Gateway ID
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}
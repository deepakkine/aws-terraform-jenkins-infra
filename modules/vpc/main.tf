# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
    Environment = var.environment
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
    Environment = var.environment
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
    Environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
    Environment = var.environment
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-public-rt"
    Environment = var.environment
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
  
}

# Default Route to Internet Gateway for Public Subnets
resource "aws_route" "default_public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
  
}

# Create NAT Gateway in the first public subnet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id  # Place the NAT gateway in the first public subnet
  tags = {
    Name = "${var.vpc_name}-nat-gateway"
    Environment = var.environment
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-private-rt"
    Environment = var.environment
  }
}

# Default Route to NAT Gateway for Private Subnets
resource "aws_route" "default_private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
  
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
  
}
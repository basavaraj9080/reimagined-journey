provider "aws" {
  region = "ap-south-1"
}

#Creating my-vpc
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "VPC-Project"
  }
}

#Creatre subnet
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-2"
  }
}

#Create IGW
resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.myvpc.id
}

#Create public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.myvpc.id
}

#Create route
resource "aws_route" "public-route" {
  route_table_id = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id
}

#Route association
resource "aws_route_table_association" "public_sunet_association" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}
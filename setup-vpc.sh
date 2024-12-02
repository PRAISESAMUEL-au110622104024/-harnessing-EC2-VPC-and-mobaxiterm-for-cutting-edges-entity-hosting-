#!/bin/bash


set -e

echo "Setting up VPC and associated resources..."

# Variables
VPC_NAME="CuttingEdgeVPC"
SUBNET_NAME="CuttingEdgeSubnet"
CIDR_BLOCK="10.0.0.0/16"
SUBNET_CIDR="10.0.1.0/24"
REGION="us-east-1"

# Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $CIDR_BLOCK --query 'Vpc.VpcId' --output text --region $REGION)
echo "VPC created with ID: $VPC_ID"

# Tag VPC
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME

# Create Subnet
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --query 'Subnet.SubnetId' --output text --region $REGION)
echo "Subnet created with ID: $SUBNET_ID"

# Tag Subnet
aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value=$SUBNET_NAME

# Create Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text --region $REGION)
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID
echo "Internet Gateway created and attached: $IGW_ID"

# Create Route Table
RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text --region $REGION)
aws ec2 create-route --route-table-id $RT_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
aws ec2 associate-route-table --route-table-id $RT_ID --subnet-id $SUBNET_ID
echo "Route Table created and configured: $RT_ID"

echo "VPC setup complete."

#!/bin/bash

# Exit on error
set -e

echo "Cleaning up resources..."

# Variables
REGION="us-east-1"

# Replace these with your resource IDs
INSTANCE_ID="i-xxxxxxxxxxxxx"
SUBNET_ID="subnet-xxxxxxxx"
VPC_ID="vpc-xxxxxxxx"
IGW_ID="igw-xxxxxxxx"
RT_ID="rtb-xxxxxxxx"
SG_ID="sg-xxxxxxxx"

# Terminate EC2 instance
aws ec2 terminate-instances --instance-ids $INSTANCE_ID --region $REGION
aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID --region $REGION
echo "EC2 instance terminated: $INSTANCE_ID"

# Delete Subnet
aws ec2 delete-subnet --subnet-id $SUBNET_ID --region $REGION
echo "Subnet deleted: $SUBNET_ID"

# Detach and delete Internet Gateway
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID --region $REGION
echo "Internet Gateway deleted: $IGW_ID"

# Delete Route Table
aws ec2 delete-route-table --route-table-id $RT_ID --region $REGION
echo "Route Table deleted: $RT_ID"

# Delete Security Group
aws ec2 delete-security-group --group-id $SG_ID --region $REGION
echo "Security Group deleted: $SG_ID"

# Delete VPC
aws ec2 delete-vpc --vpc-id $VPC_ID --region $REGION
echo "VPC deleted: $VPC_ID"

echo "Clean-up complete."

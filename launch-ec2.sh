#!/bin/bash

# Exit on error
set -e

echo "Launching EC2 instance..."

# Variables
AMI_ID="ami-0c02fb55956c7d316"  # Replace with your region-specific AMI ID
INSTANCE_TYPE="t2.micro"
KEY_NAME="CuttingEdgeKey"
SECURITY_GROUP="CuttingEdgeSG"
REGION="us-east-1"
SUBNET_ID="subnet-xxxxxxxx"  # Replace with your created Subnet ID

# Create Key Pair (if not exists)
if ! aws ec2 describe-key-pairs --key-name $KEY_NAME &>/dev/null; then
    aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > $KEY_NAME.pem
    chmod 400 $KEY_NAME.pem
    echo "Key pair created: $KEY_NAME.pem"
fi

# Create Security Group
SG_ID=$(aws ec2 create-security-group --group-name $SECURITY_GROUP --description "Allow SSH and HTTP" --vpc-id $VPC_ID --query 'GroupId' --output text --region $REGION)
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
echo "Security Group created: $SG_ID"

# Launch EC2 Instance
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SG_ID --subnet-id $SUBNET_ID --query 'Instances[0].InstanceId' --output text --region $REGION)
echo "EC2 instance launched: $INSTANCE_ID"

# Wait for EC2 to start
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION
echo "EC2 instance is running."

# Fetch public IP
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text --region $REGION)
echo "Public IP: $PUBLIC_IP"

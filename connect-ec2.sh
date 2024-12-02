#!/bin/bash

# Exit on error
set -e

# Variables
INSTANCE_ID="i-xxxxxxxxxxxxx"  # Replace with your EC2 instance ID
KEY_NAME="CuttingEdgeKey.pem"
REGION="us-east-1"

# Get public IP
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text --region $REGION)

# Output connection details
echo "To connect to your EC2 instance using MobaXterm:"
echo "Host: $PUBLIC_IP"
echo "Username: ec2-user"
echo "Key File: $KEY_NAME"

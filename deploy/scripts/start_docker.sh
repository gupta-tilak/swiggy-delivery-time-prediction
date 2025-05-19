#!/bin/bash
# Log everything to start_docker.log
exec > /home/ubuntu/start_docker.log 2>&1

echo "Logging in to ECR..."
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 107583420716.dkr.ecr.eu-north-1.amazonaws.com

echo "Pulling Docker image..."
docker pull 107583420716.dkr.ecr.eu-north-1.amazonaws.com/food_delivery_time_prediction:latest

echo "Checking for existing container..."
if [ "$(docker ps -q -f name=delivery_time_pred)" ]; then
    echo "Stopping existing container..."
    docker stop delivery_time_pred
fi

if [ "$(docker ps -aq -f name=delivery_time_pred)" ]; then
    echo "Removing existing container..."
    docker rm delivery_time_pred
fi

echo "Starting new container..."
docker run -d -p 80:8000 --name delivery_time_pred -e DAGSHUB_USER_TOKEN=289d8e405b2d4cadd725a8d50a8f22161c66fc88 107583420716.dkr.ecr.eu-north-1.amazonaws.com/food_delivery_time_prediction:latest

echo "Container started successfully."
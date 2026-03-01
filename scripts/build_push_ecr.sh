#!/usr/bin/env bash
set -euo pipefail

# Required env vars:
# AWS_REGION, AWS_ACCOUNT_ID, ECR_REPOSITORY_NAME

IMAGE_TAG="${IMAGE_TAG:-latest}"

if [[ -z "${AWS_REGION:-}" || -z "${AWS_ACCOUNT_ID:-}" || -z "${ECR_REPOSITORY_NAME:-}" ]]; then
  echo "Missing required environment variables."
  echo "Required: AWS_REGION, AWS_ACCOUNT_ID, ECR_REPOSITORY_NAME"
  exit 1
fi

ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}"

aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

docker build -t "${ECR_URI}:${IMAGE_TAG}" .
docker push "${ECR_URI}:${IMAGE_TAG}"

echo "Pushed ${ECR_URI}:${IMAGE_TAG}"

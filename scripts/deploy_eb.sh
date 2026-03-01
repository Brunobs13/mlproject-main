#!/usr/bin/env bash
set -euo pipefail

# Required env vars:
# AWS_REGION, EB_APPLICATION_NAME, EB_ENVIRONMENT_NAME, EB_S3_BUCKET

VERSION_LABEL="${VERSION_LABEL:-manual-$(date +%Y%m%d%H%M%S)}"
ZIP_FILE="${ZIP_FILE:-deploy.zip}"

if [[ -z "${AWS_REGION:-}" || -z "${EB_APPLICATION_NAME:-}" || -z "${EB_ENVIRONMENT_NAME:-}" || -z "${EB_S3_BUCKET:-}" ]]; then
  echo "Missing required environment variables."
  echo "Required: AWS_REGION, EB_APPLICATION_NAME, EB_ENVIRONMENT_NAME, EB_S3_BUCKET"
  exit 1
fi

echo "Creating bundle: ${ZIP_FILE}"
zip -r "${ZIP_FILE}" . \
  -x ".git/*" ".github/*" ".venv/*" "pastas */*" "*.pyc" "__pycache__/*" ".DS_Store"

echo "Uploading bundle to s3://${EB_S3_BUCKET}/beanstalk/${VERSION_LABEL}.zip"
aws s3 cp "${ZIP_FILE}" "s3://${EB_S3_BUCKET}/beanstalk/${VERSION_LABEL}.zip" --region "${AWS_REGION}"

echo "Creating application version: ${VERSION_LABEL}"
aws elasticbeanstalk create-application-version \
  --application-name "${EB_APPLICATION_NAME}" \
  --version-label "${VERSION_LABEL}" \
  --source-bundle S3Bucket="${EB_S3_BUCKET}",S3Key="beanstalk/${VERSION_LABEL}.zip" \
  --auto-create-application \
  --region "${AWS_REGION}"

echo "Updating environment: ${EB_ENVIRONMENT_NAME}"
aws elasticbeanstalk update-environment \
  --environment-name "${EB_ENVIRONMENT_NAME}" \
  --version-label "${VERSION_LABEL}" \
  --region "${AWS_REGION}"

echo "Done. Version ${VERSION_LABEL} submitted to Elastic Beanstalk."

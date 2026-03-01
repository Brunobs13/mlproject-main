# AWS Elastic Beanstalk Deploy (mlproject-main)

## What was adapted in this project
- Added `application.py` so Elastic Beanstalk can load `application:app`
- Fixed `.ebextensions/python.config` WSGI path to `application:app`
- Added `Dockerfile` for Docker-based builds (ECR publishing)
- Added GitHub Actions workflow: `.github/workflows/aws-eb-deploy.yml`
- Added helper scripts under `scripts/`

## Required GitHub Secrets
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `ECR_REPOSITORY_NAME`
- `EB_S3_BUCKET`
- `EB_APPLICATION_NAME`
- `EB_ENVIRONMENT_NAME`

## Deployment flow (push to `main`)
1. GitHub Actions runs optional tests (non-blocking).
2. Workflow builds Docker image and pushes to ECR.
3. Workflow packages the source code as `deploy.zip`.
4. Workflow uploads the bundle to S3.
5. Workflow creates a new Elastic Beanstalk application version.
6. Workflow updates the Elastic Beanstalk environment to the new version.

## Notes
- The current Elastic Beanstalk deploy step is **source bundle** based (Python platform).
- The Docker image push to ECR is kept for your container workflow / future EB Docker usage.
- Azure workflow remains separate and untouched.

## Local manual deploy (optional)
```bash
export AWS_REGION=eu-west-1
export EB_APPLICATION_NAME=your-app
export EB_ENVIRONMENT_NAME=your-env
export EB_S3_BUCKET=your-eb-artifacts-bucket

bash scripts/deploy_eb.sh
```

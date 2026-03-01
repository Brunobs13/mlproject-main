# ML Project - Student Performance Prediction

End-to-end machine learning project to predict `math_score` from student profile and exam context data.

The repository includes:
- Training pipeline (ingestion, transformation, model selection)
- Flask web app for single prediction
- Saved model artifacts
- Docker image support
- Deployment automation for AWS Elastic Beanstalk and Azure Web App workflows

## 1. Problem and Goal
Schools and education teams often want to estimate student math performance early, using available profile and test context fields.

This project builds a regression model that predicts `math_score` using:
- `gender`
- `race_ethnicity`
- `parental_level_of_education`
- `lunch`
- `test_preparation_course`
- `reading_score`
- `writing_score`

## 2. Project Architecture

```text
Raw CSV (notebook/data/stud.csv)
        |
        v
Data Ingestion (train/test split)
        |
        v
Data Transformation (preprocessing pipeline)
        |
        v
Model Training (model search + best model)
        |
        v
Artifacts saved in /artifacts
  - model.pkl
  - preprocessor.pkl
  - train.csv / test.csv / data.csv
        |
        v
Flask App (/predictdata)
```

## 3. Repository Structure

```text
mlproject-main/
├── app.py
├── application.py
├── Dockerfile
├── requirements.txt
├── setup.py
├── src/
│   ├── components/
│   │   ├── data_ingestion.py
│   │   ├── data_transformation.py
│   │   └── model_trainer.py
│   ├── pipeline/
│   │   ├── predict_pipeline.py
│   │   └── train_pipeline.py
│   ├── logger.py
│   ├── exception.py
│   └── utils.py
├── templates/
│   ├── index.html
│   └── home.html
├── artifacts/
├── .github/workflows/
│   ├── aws-eb-deploy.yml
│   ├── main_mlproject.yml
│   └── main_testdockerbruno.yml
├── scripts/
│   ├── build_push_ecr.sh
│   └── deploy_eb.sh
└── docs/
    └── AWS_ELASTIC_BEANSTALK_DEPLOY.md
```

## 4. Tech Stack
- Python
- pandas, numpy
- scikit-learn
- CatBoost, XGBoost
- Flask
- Docker
- GitHub Actions
- AWS ECR + Elastic Beanstalk
- Azure App Service + Azure Container Registry workflows

## 5. Local Setup

### 5.1 Create virtual environment and install
```bash
python -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### 5.2 Run training and generate artifacts
This project runs the full local training flow from `data_ingestion.py` main block:
```bash
python src/components/data_ingestion.py
```

After running, check:
- `artifacts/model.pkl`
- `artifacts/preprocessor.pkl`

### 5.3 Run the web app
```bash
python app.py
```

Open:
- `http://localhost:8080/`
- Prediction form: `http://localhost:8080/predictdata`

## 6. Docker

Build and run:
```bash
docker build -t mlproject-main:latest .
docker run -d --name mlproject-main -p 8080:8080 mlproject-main:latest
```

Then open `http://localhost:8080`.

## 7. Cloud Deployment

### 7.1 AWS Elastic Beanstalk workflow
Main AWS workflow file:
- `.github/workflows/aws-eb-deploy.yml`

Required GitHub Secrets/Variables:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `ECR_REPOSITORY_NAME`
- `EB_S3_BUCKET`
- `EB_APPLICATION_NAME`
- `EB_ENVIRONMENT_NAME`

What the workflow does:
1. Optional test step
2. Build Docker image
3. Push image to ECR
4. Create source bundle (`deploy.zip`)
5. Upload to S3
6. Create EB application version
7. Update EB environment

### 7.2 Manual AWS deploy scripts
- `scripts/build_push_ecr.sh`
- `scripts/deploy_eb.sh`

### 7.3 Azure workflows
This repo includes Azure deployment workflows for Web App and container-based release paths:
- `.github/workflows/main_mlproject.yml`
- `.github/workflows/main_testdockerbruno.yml`

This gives multi-cloud deployment coverage (AWS + Azure) in the same project.

## 8. Flask Routes
- `GET /` -> landing page
- `GET /predictdata` -> prediction form
- `POST /predictdata` -> run prediction and show result

## 9. Notes
- `application.py` exists for Elastic Beanstalk WSGI compatibility (`application:app`).
- Model and preprocessor artifacts are currently versioned in the repo.
- `src/pipeline/train_pipeline.py` is present but empty in the current codebase; training entrypoint is `src/components/data_ingestion.py`.

## 10. Next Improvements
- Add automated unit/integration tests
- Add linting and type checks in CI
- Add model performance monitoring after deployment
- Move large artifacts to dedicated model registry or object storage
- Clean duplicated/legacy deployment workflows

FROM python:3.8-slim-bullseye
WORKDIR /app
COPY . /app

RUN apt-get update && apt-get install ffmpeg libsm6 libxext6 unzip -y && pip install -r requirements.txt
CMD ["python3", "app.py"]

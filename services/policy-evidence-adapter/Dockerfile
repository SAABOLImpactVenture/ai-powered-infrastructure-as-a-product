# syntax=docker/dockerfile:1.7
FROM python:3.11-slim
WORKDIR /app
RUN pip install --no-cache-dir fastapi uvicorn requests boto3
COPY app /app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8088"]

FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM gcr.io/distroless/python3-debian12
# FROM us-west1-docker.pkg.dev/serverless-runtimes/google-22/runtimes/python312
# FROM us-west1-docker.pkg.dev/serverless-runtimes/google-22-full/runtimes/python312

WORKDIR /app
COPY --from=builder /root/.local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY . .
CMD ["sh", "-c", "exec gunicorn --bind :${PORT:-8080} --workers 1 --threads 8 --timeout 0 main:app"]

# Build
# Doesn't include the go binary
# FROM us-west1-docker.pkg.dev/serverless-runtimes/google-22/runtimes/python312 AS builder
FROM golang:1.23.10-alpine AS builder

WORKDIR /app
COPY . .
RUN go mod download
RUN go build -a -o main .

# Run
FROM scratch
COPY --from=builder /app/main /main
CMD ["/main"]

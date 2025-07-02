#!/usr/bin/bash

PROJECT=TODO
PROJECT_NUMBER=$(gcloud projects describe $PROJECT --format="value(projectNumber)")
LOCATION=us-west1
SERVICE=example
APP=
URL="https://${SERVICE}-${PROJECT_NUMBER}.${LOCATION}.run.app/${APP}"
TOKEN="$(gcloud --project=${PROJECT} auth print-identity-token)"

curl -H "Content-Type: application/json" \
     -H "Authorization: Bearer ${TOKEN}" \
     "${URL}" -d '{}'

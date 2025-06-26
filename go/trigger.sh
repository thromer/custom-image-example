#!/usr/bin/bash

curl -H "Content-Type: application/json" -H "Authorization: bearer $(gcloud --project=manage-voip-ms-001 auth print-identity-token)" https://example-698932467704.us-west1.run.app

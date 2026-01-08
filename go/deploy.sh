#!/usr/bin/bash 

set -o pipefail

shopt -s expand_aliases
source $HOME/.bash_script_aliases

PROJECT=TODO
LOCATION=us-west1
SERVICE=example
# LOGS_BUCKET=gs://${PROJECT}_build-logs
REPO=artifacts

# TIMESTAMP="$(date -u +'%Y-%m-%dT%H:%M:%S.%NZ')"
# BUILD_LOG="/tmp/${PROJECT}-${SERVICE}-build-${TIMESTAMP}.log"
# DEPLOY_LOG="/tmp/${PROJECT}-${SERVICE}-deploy-${TIMESTAMP}.log"
# ensure_logs_bucket $PROJECT $LOGS_BUCKET
# |& ts |& tee "${BUILD_LOG}"
# |& ts |& tee "${DEPLOY_LOG}"
# gcloud --project=${PROJECT} storage cp --gzip-local-all "${BUILD_LOG}" ${LOGS_BUCKET}/
# Nope: --base-image=${LOCATION}-docker.pkg.dev/serverless-runtimes/google-22-full/scratch/go123 \
# gcloud --project=${PROJECT} storage cp --gzip-local-all "${DEPLOY_LOG}" ${LOGS_BUCKET}/
# ./ensure_trigger.sh
# docker image ls -f "reference=${LOCATION}-docker.pkg.dev/${PROJECT}/artifacts/${SERVICE}*" |
#   tail -n +2 | awk '$2 != "latest" {print $3}' | xargs -r docker image rm
# gcloud artifacts docker images list \
#   --format='value(IMAGE,DIGEST)' ${LOCATION}-docker.pkg.dev/${PROJECT}/artifacts/${SERVICE} |
#	sed -e 's#\t#@#' | 
#	xargs -n 1 -r gcloud -q artifacts docker images delete >& /dev/null

cd "$(realpath "$(dirname "${BASH_SOURCE[0]}")")" &&
    ensure_repo $PROJECT $LOCATION $REPO ../repository-cleanup-policy.json &&
    docker build -t ${LOCATION}-docker.pkg.dev/${PROJECT}/artifacts/${SERVICE}:latest . |& ts &&
    ensure_docker_gcloud_auth $LOCATION
    docker push ${LOCATION}-docker.pkg.dev/${PROJECT}/artifacts/${SERVICE}:latest &&
    gcloud run deploy \
	   --project=${PROJECT} \
	   --image=${LOCATION}-docker.pkg.dev/${PROJECT}/artifacts/${SERVICE}:latest \
	   --base-image=${LOCATION}-docker.pkg.dev/serverless-runtimes/google-22/runtimes/go123 \
	   --region=${LOCATION} \
           --no-allow-unauthenticated \
	   --concurrency=1 \
	   --max-instances=5 \
	   --timeout=900 \
	   --cpu=0.2 \
	   --memory=256Mi \
	   --cpu-boost \
	   ${SERVICE}

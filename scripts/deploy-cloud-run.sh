#!/bin/bash
#
# Script Name: deploy-cloud-run.sh
# Description: Deploy a container to Cloud Run within free tier limits
# Usage: ./deploy-cloud-run.sh --project PROJECT_ID --image IMAGE_URL --service SERVICE_NAME
#
# Free Tier Limits:
# - 2 million requests per month
# - 360,000 GB-seconds of memory
# - 180,000 vCPU-seconds of compute time
# - 1GB network egress per month
#

set -euo pipefail

# Source common utilities
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/common.sh"

# Configuration variables
PROJECT_ID="${GCLOUD_PROJECT_ID:-}"
IMAGE_URL=""
SERVICE_NAME=""
REGION="${GCLOUD_REGION:-us-central1}"  # us-central1 is in the free tier
MAX_INSTANCES="${MAX_INSTANCES:-1}"      # Limit instances to control costs
MEMORY="${MEMORY:-256Mi}"                # 256Mi is sufficient for many apps
CPU="${CPU:-1}"                          # 1 vCPU
CONCURRENCY="${CONCURRENCY:-80}"         # Requests per container instance

# Functions
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Deploy a container to Google Cloud Run within free tier limits.

REQUIRED OPTIONS:
    -p, --project       GCP Project ID
    -i, --image         Container image URL (e.g., gcr.io/project/image:tag)
    -s, --service       Service name

OPTIONAL:
    -r, --region        GCP region (default: us-central1)
    -m, --memory        Memory limit (default: 256Mi)
    -c, --cpu           CPU limit (default: 1)
    --max-instances     Max container instances (default: 1)
    -h, --help          Show this help message

EXAMPLE:
    $0 --project my-project --image gcr.io/my-project/app:latest --service my-app

FREE TIER NOTES:
    - 2 million requests per month
    - 360,000 GB-seconds of memory
    - 180,000 vCPU-seconds of compute
    - Use us-central1, us-west1, or us-east1 regions

EOF
    exit "${1:-0}"
}

validate_inputs() {
    verify_project_id "$PROJECT_ID" || exit 1
    
    if [[ -z "$IMAGE_URL" ]]; then
        log_error "Container image URL is required"
        exit 1
    fi
    
    if [[ -z "$SERVICE_NAME" ]]; then
        log_error "Service name is required"
        exit 1
    fi
}

deploy_cloud_run() {
    log_info "Deploying Cloud Run service: $SERVICE_NAME"
    log_info "Image: $IMAGE_URL"
    log_info "Region: $REGION"
    log_info "Memory: $MEMORY, CPU: $CPU"
    log_info "Max instances: $MAX_INSTANCES"
    
    if ! confirm "Do you want to proceed with deployment?"; then
        log_warn "Deployment cancelled by user"
        exit 0
    fi
    
    # Enable Cloud Run API
    if ! check_api_enabled "$PROJECT_ID" "run.googleapis.com"; then
        enable_api "$PROJECT_ID" "run.googleapis.com" || exit 1
    fi
    
    # Deploy to Cloud Run
    if gcloud run deploy "$SERVICE_NAME" \
        --image="$IMAGE_URL" \
        --platform=managed \
        --region="$REGION" \
        --project="$PROJECT_ID" \
        --memory="$MEMORY" \
        --cpu="$CPU" \
        --max-instances="$MAX_INSTANCES" \
        --concurrency="$CONCURRENCY" \
        --allow-unauthenticated \
        --quiet; then
        log_info "Deployment successful!"
        
        # Get the service URL
        local service_url
        service_url=$(gcloud run services describe "$SERVICE_NAME" \
            --platform=managed \
            --region="$REGION" \
            --project="$PROJECT_ID" \
            --format="value(status.url)")
        
        log_info "Service URL: $service_url"
    else
        log_error "Deployment failed"
        exit 1
    fi
}

main() {
    log_info "Cloud Run Deployment Script"
    log_info "=============================="
    
    # Check prerequisites
    check_gcloud || exit 1
    check_gcloud_auth || exit 1
    
    # Validate inputs
    validate_inputs
    
    # Set project
    set_gcloud_project "$PROJECT_ID" || exit 1
    
    # Deploy
    deploy_cloud_run
    
    log_info "Deployment complete!"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -p|--project)
            if [[ $# -lt 2 || "$2" == -* ]]; then
                log_error "Missing value for $1"
                usage 1
            fi
            PROJECT_ID="$2"
            shift 2
            ;;
        -i|--image)
            if [[ $# -lt 2 || "$2" == -* ]]; then
                log_error "Missing value for $1"
                usage 1
            fi
            IMAGE_URL="$2"
            shift 2
            ;;
        -s|--service)
            if [[ $# -lt 2 || "$2" == -* ]]; then
                log_error "Missing value for $1"
                usage 1
            fi
            SERVICE_NAME="$2"
            shift 2
            ;;
        -r|--region)
            if [[ $# -lt 2 || "$2" == -* ]]; then
                log_error "Missing value for $1"
                usage 1
            fi
            REGION="$2"
            shift 2
            ;;
        -m|--memory)
            if [[ $# -lt 2 || "$2" == -* ]]; then
                log_error "Missing value for $1"
                usage 1
            fi
            MEMORY="$2"
            shift 2
            ;;
        -c|--cpu)
            if [[ $# -lt 2 || "$2" == -* ]]; then
                log_error "Missing value for $1"
                usage 1
            fi
            CPU="$2"
            shift 2
            ;;
        --max-instances)
            if [[ $# -lt 2 || "$2" == -* ]]; then
                log_error "Missing value for $1"
                usage 1
            fi
            MAX_INSTANCES="$2"
            shift 2
            ;;
        *)
            log_error "Unknown option: $1"
            usage 1
            ;;
    esac
done

# Run main function
main

exit 0

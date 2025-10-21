#!/bin/bash
#
# Script Name: hello-world-cloud-run.sh
# Description: Example script showing how to deploy a hello-world container to Cloud Run
# Usage: ./hello-world-cloud-run.sh
#
# This example demonstrates:
# - Using the common library functions
# - Deploying a simple container within free tier limits
# - Following the project structure conventions
#

set -euo pipefail

# Source common utilities
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/common.sh"

main() {
    log_info "Hello World Cloud Run Example"
    log_info "=============================="
    
    # Check prerequisites
    if ! check_gcloud; then
        log_error "This example requires gcloud CLI"
        exit 1
    fi
    
    if ! check_gcloud_auth; then
        log_error "Please authenticate with 'gcloud auth login'"
        exit 1
    fi
    
    # Get project ID from user
    local project_id
    echo ""
    read -r -p "Enter your GCP Project ID: " project_id
    
    if ! verify_project_id "$project_id"; then
        exit 1
    fi
    
    # Set the project
    set_gcloud_project "$project_id" || exit 1
    
    log_info ""
    log_info "This example will deploy a 'hello' container from Google's samples"
    log_info "It uses free tier limits:"
    log_info "  - Region: us-central1 (free tier eligible)"
    log_info "  - Memory: 256Mi"
    log_info "  - CPU: 1"
    log_info "  - Max instances: 1"
    log_info "  - Public access: Enabled (--allow-unauthenticated)"
    log_info ""
    
    if ! confirm "Continue with deployment?"; then
        log_warn "Example cancelled"
        exit 0
    fi
    
    # Use the deploy-cloud-run script
    local deploy_script="${SCRIPT_DIR}/../scripts/deploy-cloud-run.sh"
    
    if [[ ! -f "$deploy_script" ]]; then
        log_error "Deploy script not found: $deploy_script"
        exit 1
    fi
    
    log_info "Calling deployment script..."
    
    # Deploy using Google's sample hello container
    # Note: Using --allow-unauthenticated for public demo access
    "$deploy_script" \
        --project "$project_id" \
        --image gcr.io/cloudrun/hello \
        --service hello-world \
        --region us-central1 \
        --memory 256Mi \
        --cpu 1 \
        --max-instances 1 \
        --allow-unauthenticated
    
    log_info ""
    log_info "Example complete!"
    log_info "You can clean up by deleting the service:"
    log_info "  gcloud run services delete hello-world --region=us-central1 --project=$project_id"
}

main

exit 0

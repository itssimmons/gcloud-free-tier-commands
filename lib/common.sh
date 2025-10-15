#!/bin/bash
#
# Script Name: common.sh
# Description: Common utility functions for gcloud deployment scripts
# Usage: source this file in other scripts
#

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if gcloud CLI is installed
check_gcloud() {
    if ! command_exists gcloud; then
        log_error "gcloud CLI is not installed. Please install it from https://cloud.google.com/sdk/docs/install"
        return 1
    fi
    log_info "gcloud CLI is installed"
    return 0
}

# Check if user is authenticated with gcloud
check_gcloud_auth() {
    if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q '@'; then
        log_error "No active gcloud authentication found. Please run 'gcloud auth login'"
        return 1
    fi
    log_info "gcloud authentication verified"
    return 0
}

# Verify project ID is set
verify_project_id() {
    local project_id="$1"
    
    if [[ -z "$project_id" ]]; then
        log_error "Project ID is required but not set"
        return 1
    fi
    
    log_info "Using project: $project_id"
    return 0
}

# Set gcloud project
set_gcloud_project() {
    local project_id="$1"
    
    if ! gcloud config set project "$project_id" 2>/dev/null; then
        log_error "Failed to set project: $project_id"
        return 1
    fi
    
    log_info "Project set to: $project_id"
    return 0
}

# Check if a GCP API is enabled
check_api_enabled() {
    local project_id="$1"
    local api_name="$2"
    
    if gcloud services list --enabled --project="$project_id" --filter="name:$api_name" --format="value(name)" | grep -q "$api_name"; then
        log_info "API $api_name is enabled"
        return 0
    else
        log_warn "API $api_name is not enabled"
        return 1
    fi
}

# Enable a GCP API
enable_api() {
    local project_id="$1"
    local api_name="$2"
    
    log_info "Enabling API: $api_name"
    
    if gcloud services enable "$api_name" --project="$project_id" 2>/dev/null; then
        log_info "API $api_name enabled successfully"
        return 0
    else
        log_error "Failed to enable API: $api_name"
        return 1
    fi
}

# Confirm action with user
confirm() {
    local message="$1"
    local response
    
    read -r -p "$message [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Wait for operation to complete
wait_for_operation() {
    local operation_name="$1"
    local max_attempts="${2:-30}"
    local attempt=0
    
    log_info "Waiting for operation to complete: $operation_name"
    
    while [[ $attempt -lt $max_attempts ]]; do
        sleep 2
        ((attempt++))
        echo -n "."
    done
    
    echo ""
    log_info "Operation monitoring complete"
}

# Export functions so they can be used in scripts that source this file
export -f log_info
export -f log_warn
export -f log_error
export -f command_exists
export -f check_gcloud
export -f check_gcloud_auth
export -f verify_project_id
export -f set_gcloud_project
export -f check_api_enabled
export -f enable_api
export -f confirm
export -f wait_for_operation

# Library

This directory contains shared utility functions and libraries used by deployment scripts.

## Available Libraries

### common.sh
Common utility functions for all gcloud deployment scripts.

**Usage:**
```bash
source "$(dirname "$0")/../lib/common.sh"
```

**Available Functions:**

#### Logging Functions
- `log_info "message"` - Log informational message in green
- `log_warn "message"` - Log warning message in yellow
- `log_error "message"` - Log error message in red

#### Validation Functions
- `command_exists "command"` - Check if a command is available
- `check_gcloud` - Verify gcloud CLI is installed
- `check_gcloud_auth` - Verify user is authenticated
- `verify_project_id "project_id"` - Validate project ID is set
- `set_gcloud_project "project_id"` - Set the active gcloud project

#### API Functions
- `check_api_enabled "project_id" "api_name"` - Check if API is enabled
- `enable_api "project_id" "api_name"` - Enable a GCP API

#### Interactive Functions
- `confirm "message"` - Ask user for confirmation (y/N)
- `wait_for_operation "operation_name" [max_attempts]` - Wait for async operation

**Example:**
```bash
#!/bin/bash
source "$(dirname "$0")/../lib/common.sh"

check_gcloud || exit 1
check_gcloud_auth || exit 1

PROJECT_ID="my-project"
verify_project_id "$PROJECT_ID" || exit 1

if ! check_api_enabled "$PROJECT_ID" "run.googleapis.com"; then
    enable_api "$PROJECT_ID" "run.googleapis.com"
fi

log_info "Deployment starting..."
```

## Adding New Libraries

When adding new library files:

1. Use clear, descriptive function names
2. Export functions that should be available to scripts
3. Document each function with comments
4. Include usage examples
5. Keep libraries focused on a single purpose
6. Avoid dependencies between library files when possible

## Guidelines

- Functions should be pure when possible (no side effects)
- Always validate inputs
- Return appropriate exit codes (0 for success, 1 for failure)
- Use readonly for constants
- Prefix internal functions with underscore if not exported

# Examples

This directory contains example scripts demonstrating how to use the deployment scripts and libraries.

## Available Examples

### hello-world-cloud-run.sh
A complete example showing how to deploy a simple hello-world container to Cloud Run.

**Usage:**
```bash
./hello-world-cloud-run.sh
```

This example demonstrates:
- Interactive script execution
- Using the common library functions
- Calling deployment scripts with proper arguments
- Working within free tier limits
- Cleanup instructions

**Free Tier Compliance:**

This script meets Google Cloud Run free tier requirements through specific configuration choices:

1. **Region Selection** (`us-central1`):
   - Free tier is only available in specific regions: us-central1, us-west1, and us-east1
   - The script defaults to us-central1, which is free tier eligible

2. **Memory Allocation** (`256Mi`):
   - Free tier includes 360,000 GB-seconds of memory per month
   - With 256Mi (0.25GB), this allows ~1,440,000 seconds (~400 hours) of runtime
   - This is sufficient for low-traffic applications and testing

3. **CPU Allocation** (`1 vCPU`):
   - Free tier includes 180,000 vCPU-seconds per month
   - With 1 vCPU, this provides ~180,000 seconds (~50 hours) of active compute time
   - Actual usage is only counted when processing requests

4. **Max Instances** (`1`):
   - Limiting to 1 instance prevents unexpected scaling costs
   - Ensures predictable resource consumption
   - Suitable for development and low-traffic production apps

5. **Request Limits**:
   - Free tier allows 2 million requests per month
   - More than adequate for most small applications and testing

By combining these defaults, the script ensures deployments stay well within the always-free Cloud Run tier, making it safe for experimentation and small-scale production use without incurring charges.

**What it does:**
1. Checks for gcloud CLI installation
2. Verifies authentication
3. Prompts for project ID
4. Deploys Google's sample hello container
5. Shows the service URL
6. Provides cleanup instructions

## Running Examples

All examples are self-contained and interactive. Simply run them:

```bash
cd examples
./hello-world-cloud-run.sh
```

## Creating New Examples

When adding new examples:

1. Make examples interactive and educational
2. Include clear comments explaining each step
3. Show both successful and error handling paths
4. Provide cleanup instructions
5. Keep examples simple and focused
6. Test on a clean GCP project

## Example Template

```bash
#!/bin/bash
#
# Description: Brief description
# Demonstrates: List key concepts
#

set -euo pipefail

source "$(dirname "$0")/../lib/common.sh"

main() {
    log_info "Example: [Name]"
    
    # Setup
    # ...
    
    # Main demonstration
    # ...
    
    # Cleanup instructions
    log_info "To clean up: [cleanup commands]"
}

main
exit 0
```

## Learning Path

Recommended order for working through examples:

1. `hello-world-cloud-run.sh` - Basic Cloud Run deployment

(More examples will be added as the project grows)

# Contributing to gcloud-free-tier-commands

Thank you for your interest in contributing to this project!

## Project Structure

```
gcloud-free-tier-commands/
├── scripts/          # Main deployment scripts
├── lib/             # Shared utility functions and libraries
├── examples/        # Example usage and demonstration scripts
├── docs/            # Documentation and guides
├── LICENSE          # Project license
└── README.md        # Project overview
```

## Script Guidelines

### Naming Conventions
- Use lowercase with hyphens for script names: `deploy-app-engine.sh`
- Use descriptive names that clearly indicate the script's purpose
- All scripts should have a `.sh` extension

### Script Structure
All scripts should follow this structure:

1. **Shebang**: Start with `#!/bin/bash`
2. **Header comment**: Brief description of what the script does
3. **Set options**: Use `set -euo pipefail` for safe execution
4. **Variables**: Define configuration variables at the top
5. **Functions**: Define helper functions before main logic
6. **Main logic**: The actual script execution
7. **Exit code**: Explicit exit with appropriate code

### Example Script Template

```bash
#!/bin/bash
#
# Script Name: deploy-service.sh
# Description: Brief description of what this script does
# Usage: ./deploy-service.sh [OPTIONS]
#

set -euo pipefail

# Source common utilities if needed
# source "$(dirname "$0")/../lib/common.sh"

# Configuration variables
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ID="${GCLOUD_PROJECT_ID:-}"

# Functions
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Description of what this script does.

OPTIONS:
    -h, --help      Show this help message
    -p, --project   GCP Project ID

EXAMPLE:
    $0 --project my-project

EOF
    exit 0
}

main() {
    # Main script logic here
    echo "Deploying service..."
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -p|--project)
            PROJECT_ID="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Run main function
main

exit 0
```

### Best Practices

1. **Error Handling**
   - Always use `set -euo pipefail` at the beginning
   - Check for required commands and fail early if missing
   - Validate input parameters before using them

2. **Documentation**
   - Add comments for complex logic
   - Include usage examples in the script header
   - Keep inline comments concise and helpful

3. **Portability**
   - Avoid bash-specific features when possible
   - Test scripts on different systems
   - Use `/bin/bash` not `/bin/sh` if using bash features

4. **Security**
   - Never hardcode credentials
   - Use environment variables or secure secret management
   - Validate and sanitize all inputs

5. **Google Cloud Specific**
   - Always check if gcloud CLI is installed
   - Verify authentication before running commands
   - Use free tier limits as documented by Google Cloud
   - Include resource cleanup in scripts when appropriate

## Submitting Changes

1. Fork the repository
2. Create a new branch for your feature
3. Make your changes following the guidelines above
4. Test your scripts thoroughly
5. Submit a pull request with a clear description

## Code Review

All submissions will be reviewed for:
- Adherence to script structure guidelines
- Proper error handling
- Clear documentation
- Compliance with Google Cloud free tier limits
- Security best practices

## Questions?

Feel free to open an issue for any questions or concerns.

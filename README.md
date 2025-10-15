# gcloud-free-tier-commands

A well-structured collection of bash scripts to deploy Google Cloud services within free tier limits.

## Overview

This repository provides ready-to-use bash scripts for deploying various Google Cloud services while staying within the free tier limits. Each script is designed with best practices, proper error handling, and clear documentation.

## Repository Structure

```
gcloud-free-tier-commands/
├── scripts/          # Main deployment scripts for GCP services
├── lib/             # Shared utility functions and libraries
├── examples/        # Example usage and demonstration scripts
├── docs/            # Additional documentation and guides
├── CONTRIBUTING.md  # Contribution guidelines and script standards
├── LICENSE          # Public domain license
└── README.md        # This file
```

## Quick Start

### Prerequisites

- [Google Cloud SDK (gcloud CLI)](https://cloud.google.com/sdk/docs/install) installed
- A Google Cloud Platform account
- Authenticated with gcloud: `gcloud auth login`

### Basic Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/itssimmons/gcloud-free-tier-commands.git
   cd gcloud-free-tier-commands
   ```

2. Run an example to get started:
   ```bash
   cd examples
   ./hello-world-cloud-run.sh
   ```

3. Use deployment scripts directly:
   ```bash
   cd scripts
   ./deploy-cloud-run.sh --project YOUR_PROJECT_ID --image IMAGE_URL --service SERVICE_NAME
   ```

## Available Scripts

### Deployment Scripts (scripts/)

- **deploy-cloud-run.sh** - Deploy containers to Cloud Run within free tier limits

See [scripts/README.md](scripts/README.md) for detailed documentation.

### Utility Libraries (lib/)

- **common.sh** - Shared functions for logging, validation, and GCP operations

See [lib/README.md](lib/README.md) for API documentation.

### Examples (examples/)

- **hello-world-cloud-run.sh** - Interactive Cloud Run deployment example

See [examples/README.md](examples/README.md) for more examples and learning path.

## Free Tier Coverage

This repository aims to provide scripts for all major GCP services that offer free tier:

- ✅ **Cloud Run** - 2M requests/month, compute and memory limits
- 🔲 **App Engine** - 28 instance hours/day (planned)
- 🔲 **Cloud Functions** - 2M invocations/month (planned)
- 🔲 **Compute Engine** - f1-micro instance (planned)
- 🔲 **Cloud Storage** - 5GB storage (planned)
- 🔲 **Firestore** - 1GB storage, 50K reads/day (planned)

Legend: ✅ Available | 🔲 Planned

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:

- Script structure and naming conventions
- Coding standards and best practices
- Documentation requirements
- How to submit changes

## License

This project is released into the public domain under the [Unlicense](LICENSE). You are free to use, modify, and distribute this software without any restrictions.

## Resources

- [Google Cloud Free Tier Documentation](https://cloud.google.com/free)
- [Google Cloud SDK Documentation](https://cloud.google.com/sdk/docs)
- [Cloud Run Pricing](https://cloud.google.com/run/pricing)

## Support

- Open an [issue](https://github.com/itssimmons/gcloud-free-tier-commands/issues) for bugs or feature requests
- Check existing issues before creating a new one
- See [docs/](docs/) for additional documentation

## Disclaimer

Always monitor your Google Cloud usage to ensure you stay within free tier limits. This project is provided as-is with no guarantees. Free tier limits are subject to change by Google Cloud.

# Scripts

This directory contains the main deployment scripts for Google Cloud services within free tier limits.

## Available Scripts

### deploy-cloud-run.sh
Deploy a container to Google Cloud Run within free tier limits.

**Usage:**
```bash
./deploy-cloud-run.sh --project PROJECT_ID --image IMAGE_URL --service SERVICE_NAME
```

**Free Tier Limits:**
- 2 million requests per month
- 360,000 GB-seconds of memory
- 180,000 vCPU-seconds of compute time
- 1GB network egress per month

**Example:**
```bash
./deploy-cloud-run.sh \
  --project my-project \
  --image gcr.io/my-project/app:latest \
  --service my-app \
  --region us-central1
```

## Adding New Scripts

When adding new deployment scripts:

1. Copy `TEMPLATE.sh` as a starting point
2. Follow the guidelines in [CONTRIBUTING.md](../CONTRIBUTING.md)
3. Include free tier limits in the script header
4. Source the common library for utility functions
5. Make the script executable with `chmod +x`
6. Test thoroughly before committing
7. Document usage and examples in this README

**Quick start:**
```bash
cp TEMPLATE.sh my-new-script.sh
chmod +x my-new-script.sh
# Edit my-new-script.sh with your logic
```

## Best Practices

- Always validate inputs before executing
- Check for gcloud authentication
- Enable required APIs automatically
- Set resource limits to stay within free tier
- Include cleanup instructions in output
- Use descriptive service/resource names

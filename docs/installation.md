# Installation Guide

This guide provides detailed instructions for installing the Lightweight Edge MLOps Monitor on edge devices.

## Prerequisites

- Python 3.10 or 3.11
- Linux-based operating system (tested on Raspberry Pi OS, Ubuntu)
- At least 50MB of available RAM
- Internet connection for package installation (can run offline after installation)

## Installation Methods

### Method 1: Install from PyPI (Recommended)

```bash
pip install edge-mlops-monitor
```

### Method 2: Install from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/edge-mlops-monitor.git
   cd edge-mlops-monitor
   ```

2. Install the package:
   ```bash
   pip install -e .
   ```

## Dependencies

The following dependencies will be automatically installed:

- `psutil>=5.9.0`: For system metrics collection
- `scipy>=1.8.0`: For statistical drift detection
- `boto3>=1.24.0`: For AWS S3 integration
- `PyYAML>=6.0`: For configuration management

## AWS Credentials Setup (Optional)

If you plan to use AWS S3 for telemetry data storage, you need to set up AWS credentials:

1. Set environment variables:
   ```bash
   export AWS_ACCESS_KEY_ID=your_access_key
   export AWS_SECRET_ACCESS_KEY=your_secret_key
   export AWS_DEFAULT_REGION=your_region
   ```

2. Or create AWS credentials file:
   ```bash
   mkdir -p ~/.aws
   cat > ~/.aws/credentials << EOF
   [default]
   aws_access_key_id = your_access_key
   aws_secret_access_key = your_secret_key
   region = your_region
   EOF
   ```

## Configuration

1. Create a configuration file (e.g., `config.yaml`):
   ```bash
   # Copy the default configuration
   python -c "from edge_mlops_monitor.config import save_default_config; save_default_config('config.yaml')"
   ```

2. Edit the configuration file to match your requirements:
   ```bash
   nano config.yaml
   ```

## Verification

Verify the installation by running:

```bash
python -c "import edge_mlops_monitor; print(f'Edge MLOps Monitor version: {edge_mlops_monitor.__version__}')"
```

## Troubleshooting

### Common Issues

1. **ImportError: No module named 'edge_mlops_monitor'**
   - Ensure the package is installed correctly
   - Check your Python environment/virtual environment

2. **Permission denied when accessing system metrics**
   - Run with appropriate permissions or use sudo for system metrics collection

3. **AWS S3 access denied**
   - Verify AWS credentials are set correctly
   - Ensure the IAM user has appropriate permissions for the S3 bucket

4. **SQLite database errors**
   - Check write permissions for the directory containing the SQLite database
   - Ensure the directory exists

### Getting Help

If you encounter issues not covered here, please:
1. Check the [GitHub issues](https://github.com/yourusername/edge-mlops-monitor/issues)
2. Submit a new issue with detailed information about your problem

## Next Steps

After installation, proceed to the [Configuration Guide](configuration.md) for detailed information on configuring the monitor for your specific use case.

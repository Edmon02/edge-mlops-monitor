# Troubleshooting Guide

This document provides solutions for common issues you might encounter when using the Lightweight Edge MLOps Monitor.

## System Monitoring Issues

### High CPU Usage

**Symptoms:**
- The device becomes sluggish
- Other applications run slowly
- CPU usage is consistently high

**Possible Causes and Solutions:**

1. **Sampling interval is too short**
   - Check the `system.sampling_interval_seconds` in your configuration
   - Increase the value to reduce CPU usage (e.g., from 10 to 30 seconds)

2. **Too many metrics are being collected**
   - The system monitor collects metrics for all CPU cores by default
   - If you have a multi-core device and don't need per-core metrics, modify the code to disable per-core collection

3. **Background processes competing for resources**
   - Check for other processes running on the device
   - Consider stopping non-essential services

### Memory Leaks

**Symptoms:**
- Memory usage increases over time
- The application eventually crashes with out-of-memory errors

**Possible Causes and Solutions:**

1. **Metrics buffer not being cleared**
   - Ensure `system_monitor.clear_metrics()` is called periodically
   - Check that the buffer size limits are properly enforced

2. **SQLite database growing too large**
   - Check the `storage.max_sqlite_size_mb` setting
   - Ensure old records are being properly pruned

## Model Logging Issues

### Database Errors

**Symptoms:**
- Error messages related to SQLite
- Failed to log model inputs/outputs

**Possible Causes and Solutions:**

1. **Disk space issues**
   - Check available disk space: `df -h`
   - Free up space or configure a smaller database size limit

2. **Permission issues**
   - Ensure the application has write permissions to the database file
   - Check ownership and permissions: `ls -la path/to/database.db`

3. **Database corruption**
   - If the database becomes corrupted, you may need to delete it and start fresh
   - Backup any important data first: `cp edge_mlops_monitor.db edge_mlops_monitor.db.bak`

### Invalid Input/Output Data

**Symptoms:**
- Error messages about JSON serialization
- Failed to log certain inputs or outputs

**Possible Causes and Solutions:**

1. **Non-serializable data types**
   - Ensure all input/output data can be serialized to JSON
   - Convert complex objects to simple dictionaries before logging

2. **Very large inputs/outputs**
   - Consider truncating or summarizing large data structures
   - Implement custom serialization for large arrays or matrices

## Drift Detection Issues

### False Positives

**Symptoms:**
- Drift is detected too frequently
- Alerts for drift when there shouldn't be any

**Possible Causes and Solutions:**

1. **Threshold too high**
   - Lower the `drift_detection.threshold` value (e.g., from 0.05 to 0.01)
   - This makes the test more conservative

2. **Reference data not representative**
   - Ensure your reference data covers the expected range of values
   - Consider collecting more reference data or updating it periodically

3. **Sample size too small**
   - Increase the `drift_detection.check_frequency` to collect more samples
   - Small sample sizes can lead to statistical instability

### False Negatives

**Symptoms:**
- Drift is not detected when it should be
- Model performance degrades without alerts

**Possible Causes and Solutions:**

1. **Threshold too low**
   - Increase the `drift_detection.threshold` value (e.g., from 0.01 to 0.05)
   - This makes the test more sensitive

2. **Wrong features being monitored**
   - Ensure you're monitoring the most important features
   - Add additional features to the drift detection

## Telemetry Upload Issues

### Failed Uploads

**Symptoms:**
- Error messages about failed uploads
- Pending batch count increasing over time

**Possible Causes and Solutions:**

1. **Network connectivity issues**
   - Check network connectivity: `ping 8.8.8.8`
   - Ensure the device has internet access

2. **AWS credentials issues**
   - Verify AWS credentials are set correctly
   - Check that the IAM user has appropriate permissions

3. **S3 bucket issues**
   - Ensure the bucket exists and is accessible
   - Check bucket name and region in configuration

### High Network Usage

**Symptoms:**
- Network bandwidth is saturated
- Other network-dependent applications are slow

**Possible Causes and Solutions:**

1. **Upload interval too short**
   - Increase the `telemetry.upload_interval_seconds` value
   - This reduces the frequency of uploads

2. **Batch size too large**
   - Decrease the `telemetry.max_batch_size` value
   - This reduces the amount of data sent in each upload

## General Troubleshooting Steps

### Check Logs

The Edge MLOps Monitor logs to both the console and a log file:

```bash
# View the log file
cat edge_mlops_monitor.log

# View the last 100 lines of the log file
tail -n 100 edge_mlops_monitor.log

# Follow the log file in real-time
tail -f edge_mlops_monitor.log
```

### Check Configuration

Verify your configuration file is valid:

```bash
# Print the current configuration
python -c "from edge_mlops_monitor.config import load_config; print(load_config('config.yaml'))"
```

### Check System Resources

Monitor system resources to identify bottlenecks:

```bash
# Install htop if not already available
pip install htop

# Monitor system resources
htop

# Check disk usage
df -h

# Check memory usage
free -m
```

### Reset to Default State

If all else fails, you can reset to a default state:

1. Stop the monitor
2. Delete the SQLite database
3. Delete any log files
4. Reset the configuration to defaults
5. Restart the monitor

```bash
# Stop your application
# ...

# Delete the database and logs
rm edge_mlops_monitor.db
rm edge_mlops_monitor.log*

# Reset configuration
python -c "from edge_mlops_monitor.config import save_default_config; save_default_config('config.yaml')"

# Restart your application
# ...
```

## Getting Help

If you continue to experience issues:

1. Check the [GitHub issues](https://github.com/Edmon02/edge-mlops-monitor/issues) for similar problems
2. Submit a new issue with:
   - A description of the problem
   - Steps to reproduce
   - Relevant log output
   - Your configuration file (with sensitive information removed)
   - System information (OS, Python version, hardware specs)

# Configuration Options

This document provides detailed information about the configuration options available in the Lightweight Edge MLOps Monitor.

## Configuration File Format

The configuration file uses YAML format and is organized into several sections:

- `system`: System monitoring configuration
- `model_logging`: Model input/output logging configuration
- `drift_detection`: Drift detection configuration
- `telemetry`: Telemetry upload configuration
- `storage`: Storage configuration

## System Monitoring Configuration

| Option | Description | Default | Valid Values |
|--------|-------------|---------|-------------|
| `sampling_interval_seconds` | Interval between system metric collections | 10 | Integer ≥ 1 |
| `max_memory_buffer_mb` | Maximum memory buffer size for system metrics | 50 | Integer ≥ 1 |

Example:
```yaml
system:
  sampling_interval_seconds: 5
  max_memory_buffer_mb: 25
```

## Model Logging Configuration

| Option | Description | Default | Valid Values |
|--------|-------------|---------|-------------|
| `buffer_size` | Maximum number of model inputs/outputs to keep in buffer | 1000 | Integer ≥ 1 |
| `log_level` | Log level for model logging | INFO | DEBUG, INFO, WARNING, ERROR, CRITICAL |

Example:
```yaml
model_logging:
  buffer_size: 500
  log_level: DEBUG
```

## Drift Detection Configuration

| Option | Description | Default | Valid Values |
|--------|-------------|---------|-------------|
| `algorithm` | Drift detection algorithm to use | ks_test | ks_test |
| `threshold` | P-value threshold for drift detection | 0.05 | Float between 0 and 1 |
| `reference_data_path` | Path to reference data file (JSON format) | reference_data.json | Valid file path |
| `check_frequency` | Check for drift after every N predictions | 100 | Integer ≥ 1 |

Example:
```yaml
drift_detection:
  algorithm: ks_test
  threshold: 0.01
  reference_data_path: "/path/to/reference_data.json"
  check_frequency: 50
```

## Telemetry Configuration

| Option | Description | Default | Valid Values |
|--------|-------------|---------|-------------|
| `upload_interval_seconds` | Interval between telemetry upload attempts | 300 | Integer ≥ 1 |
| `max_batch_size` | Maximum number of records to include in a single batch | 100 | Integer ≥ 1 |
| `retry_base_delay_seconds` | Base delay for exponential backoff retry | 1 | Integer ≥ 1 |
| `retry_max_delay_seconds` | Maximum delay for exponential backoff retry | 60 | Integer ≥ 1 |
| `retry_max_attempts` | Maximum number of retry attempts | 5 | Integer ≥ 1 |

Example:
```yaml
telemetry:
  upload_interval_seconds: 600
  max_batch_size: 50
  retry_base_delay_seconds: 2
  retry_max_delay_seconds: 120
  retry_max_attempts: 3
```

## Storage Configuration

| Option | Description | Default | Valid Values |
|--------|-------------|---------|-------------|
| `type` | Storage type for telemetry data | s3 | s3, sqlite |
| `bucket` | S3 bucket name for telemetry data | your-telemetry-bucket | Valid S3 bucket name |
| `prefix` | S3 key prefix for telemetry data | edge-device-1/ | Valid S3 prefix |
| `sqlite_path` | Path to SQLite database for local storage | edge_mlops_monitor.db | Valid file path |
| `max_sqlite_size_mb` | Maximum size of SQLite database | 100 | Integer ≥ 1 |

Example:
```yaml
storage:
  type: "s3"
  bucket: "my-edge-telemetry"
  prefix: "device-123/"
  sqlite_path: "/data/edge_mlops_monitor.db"
  max_sqlite_size_mb: 200
```

## Resource Usage Considerations

Different configuration settings have different impacts on resource usage:

### CPU Usage
- Lower `sampling_interval_seconds` increases CPU usage
- Lower `drift_detection.check_frequency` increases CPU usage
- Higher `telemetry.max_batch_size` can cause CPU spikes during serialization

### Memory Usage
- Higher `system.max_memory_buffer_mb` increases memory usage
- Higher `model_logging.buffer_size` increases memory usage
- Higher `storage.max_sqlite_size_mb` can increase memory usage during database operations

### Disk Usage
- Higher `storage.max_sqlite_size_mb` increases disk usage
- Higher `model_logging.buffer_size` increases disk usage when using SQLite storage

### Network Usage
- Lower `telemetry.upload_interval_seconds` increases network usage
- Higher `telemetry.max_batch_size` increases burst network usage but may be more efficient overall

## Example Configurations

### Minimal Resource Usage (e.g., for IoT sensors)
```yaml
system:
  sampling_interval_seconds: 60
  max_memory_buffer_mb: 10

model_logging:
  buffer_size: 100
  log_level: WARNING

drift_detection:
  algorithm: ks_test
  threshold: 0.01
  reference_data_path: "reference_data.json"
  check_frequency: 500

telemetry:
  upload_interval_seconds: 3600
  max_batch_size: 50
  retry_base_delay_seconds: 5
  retry_max_delay_seconds: 300
  retry_max_attempts: 3

storage:
  type: "sqlite"
  sqlite_path: "edge_mlops_monitor.db"
  max_sqlite_size_mb: 50
```

### Balanced Configuration (e.g., for Raspberry Pi)
```yaml
system:
  sampling_interval_seconds: 30
  max_memory_buffer_mb: 25

model_logging:
  buffer_size: 500
  log_level: INFO

drift_detection:
  algorithm: ks_test
  threshold: 0.05
  reference_data_path: "reference_data.json"
  check_frequency: 100

telemetry:
  upload_interval_seconds: 900
  max_batch_size: 100
  retry_base_delay_seconds: 2
  retry_max_delay_seconds: 120
  retry_max_attempts: 5

storage:
  type: "s3"
  bucket: "edge-telemetry"
  prefix: "raspberry-pi/"
  sqlite_path: "edge_mlops_monitor.db"
  max_sqlite_size_mb: 100
```

### Higher Resource Usage (e.g., for NVIDIA Jetson)
```yaml
system:
  sampling_interval_seconds: 5
  max_memory_buffer_mb: 100

model_logging:
  buffer_size: 2000
  log_level: DEBUG

drift_detection:
  algorithm: ks_test
  threshold: 0.05
  reference_data_path: "reference_data.json"
  check_frequency: 50

telemetry:
  upload_interval_seconds: 300
  max_batch_size: 200
  retry_base_delay_seconds: 1
  retry_max_delay_seconds: 60
  retry_max_attempts: 10

storage:
  type: "s3"
  bucket: "edge-telemetry"
  prefix: "jetson/"
  sqlite_path: "edge_mlops_monitor.db"
  max_sqlite_size_mb: 500
```

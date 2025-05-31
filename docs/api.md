# API Reference

This document provides detailed information about the API of the Lightweight Edge MLOps Monitor.

## EdgeMonitor

The main class that integrates all monitoring components.

### Initialization

```python
from edge_mlops_monitor import EdgeMonitor

monitor = EdgeMonitor(config_path=None, device_id="")
```

**Parameters:**
- `config_path` (Optional[str]): Path to the configuration file. If None, uses default config.
- `device_id` (str): Unique identifier for the device. If empty, auto-generated.

### Methods

#### System Monitoring

```python
# Start system monitoring in the background
monitor.start_system_monitoring()

# Stop system monitoring
monitor.stop_system_monitoring()
```

#### Model Logging

```python
# Log a model input
input_id = monitor.log_model_input(input_data)

# Log a model output
output_id = monitor.log_model_output(input_id, output_data)
```

**Parameters:**
- `input_data` (Dict[str, Any]): Model input data as a dictionary.
- `input_id` (str): ID of the corresponding input.
- `output_data` (Dict[str, Any]): Model output data as a dictionary.

**Returns:**
- `input_id` (str): ID of the logged input.
- `output_id` (str): ID of the logged output.

#### Drift Detection

```python
# Set reference data for drift detection
monitor.set_reference_data(feature_name, values)

# Save current reference data to file
monitor.save_reference_data(output_path=None)
```

**Parameters:**
- `feature_name` (str): Name of the feature.
- `values` (List[float]): Reference values for the feature.
- `output_path` (Optional[str]): Path to save the reference data. If None, uses the path from config.

#### Telemetry

```python
# Start telemetry upload in the background
monitor.start_telemetry_upload()

# Stop telemetry upload
monitor.stop_telemetry_upload()

# Create a telemetry batch with current data
batch_id = monitor.create_telemetry_batch(
    include_system=True,
    include_model=True,
    include_drift=True,
    max_records=100
)
```

**Parameters:**
- `include_system` (bool): Whether to include system metrics.
- `include_model` (bool): Whether to include model inputs/outputs.
- `include_drift` (bool): Whether to include drift results.
- `max_records` (int): Maximum number of records to include.

**Returns:**
- `batch_id` (str): ID of the created batch.

#### Monitor Control

```python
# Start all monitoring components
monitor.start()

# Stop all monitoring components
monitor.stop()

# Get the current status of the monitor
status = monitor.get_status()
```

**Returns:**
- `status` (Dict[str, Any]): Dictionary with status information.

## SystemMonitor

The system health monitoring component.

### Initialization

```python
from edge_mlops_monitor.system import SystemMonitor
from edge_mlops_monitor.config import load_config

config = load_config("config.yaml")
system_monitor = SystemMonitor(config, device_id="")
```

**Parameters:**
- `config` (MonitorConfig): Monitor configuration.
- `device_id` (str): Unique identifier for the device.

### Methods

```python
# Start system monitoring
system_monitor.start()

# Stop system monitoring
system_monitor.stop()

# Get collected metrics
metrics = system_monitor.get_metrics()

# Clear metrics buffer
system_monitor.clear_metrics()
```

**Returns:**
- `metrics` (List[SystemMetric]): List of system metrics.

## ModelLogger

The model input/output logging component.

### Initialization

```python
from edge_mlops_monitor.model_logger import ModelLogger
from edge_mlops_monitor.config import load_config

config = load_config("config.yaml")
model_logger = ModelLogger(config, device_id="", db_path=None)
```

**Parameters:**
- `config` (MonitorConfig): Monitor configuration.
- `device_id` (str): Unique identifier for the device.
- `db_path` (Optional[str]): Path to the SQLite database. If None, uses the path from config.

### Methods

```python
# Log a model input
input_id = model_logger.log_input(input_data)

# Log a model output
output_id = model_logger.log_output(input_id, output_data)

# Get logged model inputs
inputs = model_logger.get_inputs(limit=100, offset=0)

# Get logged model outputs
outputs = model_logger.get_outputs(limit=100, offset=0)

# Get paired model inputs and outputs
pairs = model_logger.get_input_output_pairs(limit=100, offset=0)

# Clear all logs
model_logger.clear_logs()
```

**Parameters:**
- `input_data` (Dict[str, Any]): Model input data.
- `input_id` (str): ID of the corresponding input.
- `output_data` (Dict[str, Any]): Model output data.
- `limit` (int): Maximum number of records to retrieve.
- `offset` (int): Offset for pagination.

**Returns:**
- `input_id` (str): ID of the logged input.
- `output_id` (str): ID of the logged output.
- `inputs` (List[ModelInput]): List of model inputs.
- `outputs` (List[ModelOutput]): List of model outputs.
- `pairs` (List[Tuple[ModelInput, ModelOutput]]): List of (input, output) tuples.

## DriftDetector

The drift detection component.

### Initialization

```python
from edge_mlops_monitor.drift import DriftDetector
from edge_mlops_monitor.model_logger import ModelLogger
from edge_mlops_monitor.config import load_config

config = load_config("config.yaml")
model_logger = ModelLogger(config)
drift_detector = DriftDetector(config, model_logger, device_id="")
```

**Parameters:**
- `config` (MonitorConfig): Monitor configuration.
- `model_logger` (ModelLogger): Model logger instance.
- `device_id` (str): Unique identifier for the device.

### Methods

```python
# Set reference data for a feature
drift_detector.set_reference_data(feature_name, values)

# Save current reference data to file
drift_detector.save_reference_data(output_path=None)

# Detect drift for a specific feature
result = drift_detector.detect_drift(feature_name, current_values)

# Check drift using recent model outputs
results = drift_detector.check_drift_from_recent_outputs(feature_names, sample_size=100)

# Get all drift detection results
all_results = drift_detector.get_drift_results()

# Clear all drift detection results
drift_detector.clear_drift_results()
```

**Parameters:**
- `feature_name` (str): Name of the feature.
- `values` (List[float]): Reference values for the feature.
- `current_values` (List[float]): Current values for the feature.
- `output_path` (Optional[str]): Path to save the reference data.
- `feature_names` (List[str]): Names of the features to check.
- `sample_size` (int): Number of recent outputs to use.

**Returns:**
- `result` (DriftResult): Drift detection result.
- `results` (Dict[str, DriftResult]): Dictionary mapping feature names to drift detection results.
- `all_results` (List[DriftResult]): List of drift detection results.

## TelemetryUploader

The telemetry upload component.

### Initialization

```python
from edge_mlops_monitor.upload import TelemetryUploader
from edge_mlops_monitor.config import load_config

config = load_config("config.yaml")
telemetry_uploader = TelemetryUploader(config, device_id="")
```

**Parameters:**
- `config` (MonitorConfig): Monitor configuration.
- `device_id` (str): Unique identifier for the device.

### Methods

```python
# Start telemetry upload
telemetry_uploader.start()

# Stop telemetry upload
telemetry_uploader.stop()

# Create a telemetry batch
batch_id = telemetry_uploader.create_batch(
    system_metrics=[],
    model_inputs=[],
    model_outputs=[],
    drift_results=[]
)

# Get the number of pending telemetry batches
count = telemetry_uploader.get_pending_batch_count()

# Clear uploaded telemetry batches
cleared = telemetry_uploader.clear_uploaded_batches(older_than_days=7)
```

**Parameters:**
- `system_metrics` (List[SystemMetric]): System metrics to include in the batch.
- `model_inputs` (List[ModelInput]): Model inputs to include in the batch.
- `model_outputs` (List[ModelOutput]): Model outputs to include in the batch.
- `drift_results` (List[DriftResult]): Drift detection results to include in the batch.
- `older_than_days` (int): Only clear batches older than this many days.

**Returns:**
- `batch_id` (str): ID of the created batch.
- `count` (int): Number of pending batches.
- `cleared` (int): Number of batches cleared.

## Configuration

The configuration module.

### Functions

```python
from edge_mlops_monitor.config import load_config, save_default_config

# Load configuration from a YAML file
config = load_config(config_path=None)

# Save the default configuration to a YAML file
save_default_config(output_path="config.yaml")
```

**Parameters:**
- `config_path` (Optional[str]): Path to the configuration file. If None, uses default config.
- `output_path` (str): Path to save the default configuration.

**Returns:**
- `config` (MonitorConfig): Validated configuration dictionary.

## Data Types

### SystemMetric

```python
class SystemMetric(TypedDict):
    timestamp: float
    metric_type: str
    value: float
    device_id: str
```

### ModelInput

```python
class ModelInput(TypedDict):
    id: str
    timestamp: float
    input_data: Dict[str, Any]
    device_id: str
```

### ModelOutput

```python
class ModelOutput(TypedDict):
    id: str
    input_id: str
    timestamp: float
    output_data: Dict[str, Any]
    device_id: str
```

### DriftResult

```python
class DriftResult(TypedDict):
    timestamp: float
    algorithm: str
    feature_name: str
    statistic: float
    p_value: float
    threshold: float
    is_drift: bool
    sample_size: int
    device_id: str
```

### TelemetryBatch

```python
class TelemetryBatch(TypedDict):
    batch_id: str
    timestamp: float
    device_id: str
    system_metrics: List[SystemMetric]
    model_inputs: List[ModelInput]
    model_outputs: List[ModelOutput]
    drift_results: List[DriftResult]
```

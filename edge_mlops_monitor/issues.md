# Edge MLOps Monitor - Issues and Fixes

```python
# CRITICAL: Security vulnerability in AWS credentials handling
# Current implementation might expose credentials in logs
# Priority: Immediate - Needs security review
# File: upload.py
```

## Identified Issues

### 1. Logging Configuration Error
- **File**: `monitor.py`
- **Issue**: Using `logging.FileHandler` with `maxBytes` parameter which is not supported
- **Fix**: Replace with `RotatingFileHandler` from `logging.handlers`
- **Status**: ✅ Fixed

### 2. Test Configuration Issues
- **File**: `conftest.py` (created)
- **Issue**: Tests using S3 storage by default, requiring credentials
- **Fix**: Override configuration to use SQLite for tests
- **Status**: ✅ Fixed

### 3. Drift Detection Algorithm Configuration
- **File**: `conftest.py`
- **Issue**: Configuration not isolated between tests, causing invalid algorithm errors
- **Fix**: Provide fresh configuration copy for each test with valid algorithm
- **Status**: ✅ Fixed

### 4. Custom Config Loading Error
- **File**: `test_config.py`
- **Issue**: TypeError: a bytes-like object is required, not 'str'
- **Details**: Issue in test_load_custom_config when writing YAML file
- **Status**: ⏳ To be fixed

### 5. Drift Results Copy Issue
- **File**: `test_drift.py`
- **Issue**: AssertionError: 'modified' != 'feature1' in test_get_drift_results
- **Details**: get_drift_results() not returning a proper copy of drift results
- **Status**: ⏳ To be fixed

### 6. System Metrics Collection Issue
- **File**: `test_system.py`
- **Issue**: AssertionError: 7 != 6 in test_collect_metrics
- **Details**: Incorrect number of metrics being collected
- **Status**: ⏳ To be fixed

### 7. System Metrics Value Issue
- **File**: `test_system.py`
- **Issue**: AssertionError: 99.0 != 42.0 in test_get_metrics
- **Details**: get_metrics() not returning correct values
- **Status**: ⏳ To be fixed

### 8. Asyncio Event Loop Issues
- **File**: `test_system.py`, `test_upload.py`
- **Issue**: RuntimeError: no running event loop in test_start_stop
- **Details**: Asyncio event loop not properly set up in tests
- **Status**: ⏳ To be fixed

### 9. S3 Upload Mocking Issues
- **File**: `test_upload.py`
- **Issue**: AssertionError: False is not true in test_upload_batch_success
- **Details**: Mock not properly configured for S3 upload success
- **Status**: ⏳ To be fixed

### 10. Batch Upload Verification Issue
- **File**: `test_upload.py`
- **Issue**: AssertionError: 0 != 3 in test_upload_pending_batches
- **Details**: Batches not being marked as uploaded
- **Status**: ⏳ To be fixed

### 11. Asyncio Coroutine Warnings
- **File**: Multiple test files
- **Issue**: RuntimeWarning: coroutine was never awaited
- **Details**: Asyncio coroutines not properly awaited in tests
- **Status**: ⏳ To be fixed

## Fix Plan

1. Fix custom config loading in test_config.py
2. Fix drift results copy issue in drift.py
3. Fix system metrics collection and value issues in system.py
4. Fix asyncio event loop issues in system.py and upload.py
5. Fix S3 upload mocking and batch verification in upload.py
6. Fix asyncio coroutine warnings in test files
7. Run comprehensive tests to verify all fixes

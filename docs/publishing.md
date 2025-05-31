# Publishing Guide for Edge MLOps Monitor

This guide explains how to publish the Edge MLOps Monitor package to both TestPyPI and PyPI.

## Prerequisites

1. Create accounts and API tokens (one-time setup):
   - TestPyPI account: https://test.pypi.org/account/register/
   - TestPyPI API token: https://test.pypi.org/manage/account/token/
   - PyPI account: https://pypi.org/account/register/
   - PyPI API token: https://pypi.org/manage/account/token/

2. Install required tools:
```bash
pip install --upgrade build twine
```

## Publishing Process

### Step 1: Update Version Number
Before publishing, update the version number in `pyproject.toml`:
```toml
[project]
name = "edge_mlops_monitor"
version = "x.y.z"  # Update this version number
```

### Step 2: Clean Previous Builds
Remove old build artifacts:
```bash
rm -rf dist/ build/ *.egg-info/
```

### Step 3: Build Distribution Packages
Build both wheel and source distribution:
```bash
python -m build
```

### Step 4: Test on TestPyPI First (Recommended)

1. Upload to TestPyPI:
```bash
python -m twine upload --repository testpypi dist/*
```

2. Test the installation from TestPyPI:
```bash
pip install --index-url https://test.pypi.org/simple/ edge-mlops-monitor
```

3. Verify the installation:
```python
import edge_mlops_monitor
print(edge_mlops_monitor.__version__)
```

### Step 5: Upload to Production PyPI

If testing on TestPyPI was successful, upload to the real PyPI:
```bash
python -m twine upload dist/*
```

## Updating an Existing Package

When you make changes to your library and want to publish the updates:

1. <span style="color:red">**IMPORTANT**:</span> You MUST increment the version number in `pyproject.toml`. PyPI and TestPyPI do not allow re-uploading the same version, even if the code has changed.

2. Follow this version update process:
   ```bash
   # 1. Update version in pyproject.toml from "0.1.0" to "0.1.1" (for example)
   
   # 2. Clean old builds
   rm -rf dist/ build/ *.egg-info/
   
   # 3. Build new distribution
   python -m build
   
   # 4. Upload to TestPyPI first
   python -m twine upload --repository testpypi dist/*
   
   # 5. Test the new version
   pip install --index-url https://test.pypi.org/simple/ edge-mlops-monitor --upgrade
   
   # 6. If tests pass, upload to PyPI
   python -m twine upload dist/*
   ```

### Version Numbering Guidelines for Updates
- For bug fixes: increment the PATCH version (0.1.0 → 0.1.1)
- For new features: increment the MINOR version (0.1.1 → 0.2.0)
- For breaking changes: increment the MAJOR version (0.2.0 → 1.0.0)

## Common Issues and Solutions

### Version Conflict or 400 Bad Request
If you get an error about version conflict or a 400 Bad Request:
1. The version number in `pyproject.toml` has already been used
2. You MUST increment the version number (you cannot reuse a version)
3. Clean and rebuild the distribution
4. Try uploading again with the new version

### Authentication Issues
- Make sure you're using the correct API token
- Check that your `.pypirc` file is configured correctly:
```ini
[distutils]
index-servers =
    pypi
    testpypi

[pypi]
username = __token__
password = ...
repository = https://upload.pypi.org/legacy/

[testpypi]
username = __token__
password = ...
repository = https://test.pypi.org/legacy/
```

### Distribution Issues
If your package is not installing correctly:
1. Check the package structure
2. Verify `pyproject.toml` configuration
3. Make sure all required files are included in the distribution
4. Review the `MANIFEST.in` file if you have one

## Version Numbering

Follow semantic versioning (MAJOR.MINOR.PATCH):
- MAJOR: Incompatible API changes
- MINOR: Add functionality (backwards-compatible)
- PATCH: Bug fixes (backwards-compatible)

Example: 1.0.1 → 1.1.0 for new features

## Release Checklist

Before publishing:
- [ ] Update version number
- [ ] Update CHANGELOG.md (if exists)
- [ ] Run all tests (`pytest`)
- [ ] Clean old builds
- [ ] Build new distribution
- [ ] Test on TestPyPI
- [ ] Upload to PyPI
- [ ] Verify installation from PyPI
- [ ] Tag the release in git:
```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

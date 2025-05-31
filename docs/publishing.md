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

## Common Issues and Solutions

### Version Conflict
If you get an error about version already existing:
1. Update the version number in `pyproject.toml`
2. Clean and rebuild the distribution
3. Try uploading again

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

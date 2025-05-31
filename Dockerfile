FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the package
COPY . .

# Install the package
RUN pip install -e .

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Command to run when the container starts
CMD ["python", "-c", "import time; from edge_mlops_monitor import EdgeMonitor; monitor = EdgeMonitor(); monitor.start(); print('Edge MLOps Monitor started'); time.sleep(float('inf'))"]

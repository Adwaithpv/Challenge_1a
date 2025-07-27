FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    poppler-utils \
    build-essential \
    cmake \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libgcc-s1 \
    git \
    # OpenCV dependencies
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Create input and output directories
RUN mkdir -p /app/input /app/output

# Copy requirements and install Python dependencies
COPY requirements.txt .

# Install PyTorch CPU version first
RUN pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cpu

# Install numpy explicitly to avoid build conflicts
RUN pip install --no-cache-dir "numpy>=1.21.0,<1.25.0"

# Install detectron2 from source (more reliable than pre-built wheels)
RUN pip install --no-cache-dir 'git+https://github.com/facebookresearch/detectron2.git'

# Install other dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Create missing __init__.py files for all Python packages (this handles all directories safely)
RUN find /app/src -type d -exec touch {}/__init__.py \;

# Install the package in development mode to handle dependencies
RUN pip install -e .

# Ensure models directory exists and is accessible
RUN mkdir -p /app/models && chmod -R 755 /app/models

# Ensure xmls directory exists and is accessible
RUN mkdir -p /app/xmls && chmod -R 755 /app/xmls

# Create a symlink for model configurations if they don't exist
RUN if [ ! -f /app/models/config.json ]; then echo '{}' > /app/models/config.json; fi

# Set environment variables for CPU-only execution and proper module resolution
ENV CUDA_VISIBLE_DEVICES=""
ENV TF_CPP_MIN_LOG_LEVEL="2"
ENV PYTHONPATH="/app:/app/src"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Make the entrypoint script executable
RUN chmod +x docker_entrypoint.py

# Set the entrypoint
ENTRYPOINT ["python", "docker_entrypoint.py"] 
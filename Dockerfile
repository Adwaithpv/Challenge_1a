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
    && rm -rf /var/lib/apt/lists/*

# Create input and output directories
RUN mkdir -p /app/input /app/output

# Copy requirements and install Python dependencies
COPY requirements.txt .

# Install PyTorch CPU version first
RUN pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cpu

# Install detectron2 from source (more reliable than pre-built wheels)
RUN pip install --no-cache-dir 'git+https://github.com/facebookresearch/detectron2.git'

# Install other dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Create missing __init__.py files for all Python packages
RUN find /app/src -type d -exec touch {}/__init__.py \;

# Create __init__.py files for specific directories that need them
RUN echo "# Package initialization" > /app/src/__init__.py && \
    echo "# Package initialization" > /app/src/data_model/__init__.py && \
    echo "# Package initialization" > /app/src/extraction_formats/__init__.py && \
    echo "# Package initialization" > /app/src/fast_trainer/__init__.py && \
    echo "# Package initialization" > /app/src/model_configuration/__init__.py && \
    echo "# Package initialization" > /app/src/pdf_features/__init__.py && \
    echo "# Package initialization" > /app/src/pdf_features/tests/__init__.py && \
    echo "# Package initialization" > /app/src/pdf_layout_analysis/__init__.py && \
    echo "# Package initialization" > /app/src/pdf_token_type_labels/__init__.py && \
    echo "# Package initialization" > /app/src/pdf_tokens_type_trainer/__init__.py && \
    echo "# Package initialization" > /app/src/pdf_tokens_type_trainer/tests/__init__.py && \
    echo "# Package initialization" > /app/src/toc/__init__.py && \
    echo "# Package initialization" > /app/src/toc/data/__init__.py && \
    echo "# Package initialization" > /app/src/toc/methods/__init__.py && \
    echo "# Package initialization" > /app/src/toc/methods/two_models_v3_segments_context_2/__init__.py && \
    echo "# Package initialization" > /app/src/vgt/__init__.py

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
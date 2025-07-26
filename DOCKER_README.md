# Docker Setup for Adobe India Hackathon - Round 1A

This document contains the Docker setup and execution instructions for the Round 1A PDF processing solution.

## 🐳 Container Overview

The Docker container automatically processes all PDF files from `/app/input` directory and generates corresponding JSON files in `/app/output` directory with document structure extraction (title and hierarchical headings).

## 🏗️ Building the Docker Image

Build the Docker image using the exact command format expected by the hackathon:

```bash
docker build --platform linux/amd64 -t mysolutionname:somerandomidentifier .
```

### Example Build Commands

```bash
# Example with specific names
docker build --platform linux/amd64 -t round1a-solution:v1.0 .

# Example with team name
docker build --platform linux/amd64 -t team-awesome-pdf:hackathon2024 .
```

## 🚀 Running the Container

Run the solution using the exact command format specified in the hackathon requirements:

```bash
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output --network none mysolutionname:somerandomidentifier
```

### Important Notes

- **Input Directory**: Place your PDF files in a local `input/` directory
- **Output Directory**: Results will be saved to a local `output/` directory
- **Network Isolation**: `--network none` ensures offline operation as required
- **Auto-cleanup**: `--rm` automatically removes the container after execution

## 📁 Directory Structure

Before running, ensure your directory structure looks like this:

```
your-project/
├── input/                    # Create this directory
│   ├── document1.pdf        # Your PDF files
│   ├── document2.pdf
│   └── report.pdf
├── output/                   # Create this directory (will be populated by container)
└── ... (other project files)
```

## 📋 Complete Example Workflow

### 1. Prepare Directories

```bash
# Create input and output directories
mkdir -p input output

# Copy your PDF files to input directory
cp /path/to/your/pdfs/*.pdf input/
```

### 2. Build the Docker Image

```bash
docker build --platform linux/amd64 -t pdf-processor:hackathon .
```

### 3. Run the Processing

```bash
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output --network none pdf-processor:hackathon
```

### 4. Check Results

```bash
# List generated JSON files
ls -la output/

# View a result file
cat output/document1.json
```

## 📄 Expected Output Format

For each `filename.pdf` in the input directory, the container generates a corresponding `filename.json` with the following structure:

```json
{
  "title": "Document Title Here",
  "outline": [
    {
      "level": "H1",
      "text": "First Level Heading", 
      "page": 1
    },
    {
      "level": "H2", 
      "text": "Second Level Heading",
      "page": 3
    },
    {
      "level": "H3",
      "text": "Third Level Heading", 
      "page": 5
    }
  ]
}
```

## 🔧 Container Features

### ✅ Automatic Processing
- Discovers all PDF files in `/app/input`
- Processes them in parallel for optimal performance
- Generates corresponding JSON files in `/app/output`

### ✅ Error Handling
- Continues processing even if individual files fail
- Creates error JSON files for failed PDFs
- Provides detailed processing logs

### ✅ Performance Optimized
- Uses optimized parallel processing
- Memory management for large files
- CPU-only execution (no GPU required)

### ✅ Offline Operation
- No internet connection required
- All models and dependencies included in container
- Complies with hackathon requirements

## 📊 Container Logs

The container provides detailed logging during execution:

```
🚀 Adobe India Hackathon - Round 1A PDF Processing Container
============================================================
📁 Input directory: /app/input
📁 Output directory: /app/output
📊 Found 3 PDF file(s) to process:
   • document1.pdf
   • document2.pdf
   • report.pdf

============================================================
🔄 Starting PDF processing...
============================================================
📄 Processing: document1.pdf
✅ Completed: document1.pdf → document1.json (4.23s)
📄 Processing: document2.pdf  
✅ Completed: document2.pdf → document2.json (2.81s)
📄 Processing: report.pdf
✅ Completed: report.pdf → report.json (6.45s)

============================================================
📋 PROCESSING SUMMARY
============================================================
Total files: 3
✅ Successful: 3
❌ Failed: 0
⏱️  Total time: 13.49s
📊 Average time per file: 4.50s

📄 Generated output files:
   • document1.json
   • document2.json  
   • report.json

🎯 Processing completed! Results saved to /app/output
```

## 🐛 Troubleshooting

### Common Issues

**1. Permission Issues**
```bash
# Make sure directories are writable
chmod 755 input output
```

**2. Platform Issues**
```bash
# On ARM Macs, ensure you're building for linux/amd64
docker build --platform linux/amd64 -t your-image:tag .
```

**3. No PDF Files Found**
```bash
# Verify PDF files are in input directory
ls -la input/
```

**4. Container Exits Immediately**
```bash
# Check container logs
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output pdf-processor:hackathon
```

### Memory Issues

If processing large PDFs (>100MB), the container automatically uses memory-optimized processing.

### Container Size

The built image is approximately 2-3 GB due to ML model dependencies. This is normal for document AI applications.

## 🏆 Hackathon Submission

### Required Files

Ensure your submission includes:
- `Dockerfile`
- `docker_entrypoint.py`
- `requirements.txt`
- `.dockerignore`
- All source code (`src/` directory)
- Pre-trained models (`models/` directory)

### Submission Commands

The hackathon organizers will use these exact commands:

```bash
# Build
docker build --platform linux/amd64 -t mysolutionname:somerandomidentifier .

# Run
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output --network none mysolutionname:somerandomidentifier
```

## 📝 Notes for Judges

- **Performance**: Optimized for CPU-only execution with parallel processing
- **Memory**: Includes memory management for large files
- **Reliability**: Robust error handling and validation
- **Compliance**: Meets all hackathon requirements (offline, JSON output, etc.)
- **Format**: Outputs exactly match the required schema

---

## 🆘 Support

If you encounter issues during the hackathon evaluation, check:
1. PDF files are properly mounted to `/app/input`
2. Output directory is writable and mounted to `/app/output`
3. Platform is set to `linux/amd64`
4. No network connectivity issues (container should work offline)

The container is designed to be fully self-contained and work reliably in the hackathon evaluation environment. 
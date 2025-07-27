# Round 1A Solution - Adobe India Hackathon

A robust PDF document structure extraction system that extracts document titles and hierarchical headings from PDF files, optimized for the Adobe India Hackathon Round 1A requirements.

## 🎯 Overview

This solution extracts structured outlines from PDF files, identifying document titles and hierarchical headings (H1, H2, H3, etc.) with their corresponding page numbers. The system is designed to work offline without internet access and process documents efficiently using Docker containers.

## ⚡ Requirements

- **Performance**: Process 50 pages in <10 seconds
- **Memory**: Stay within 16GB RAM
- **Offline**: Work without internet access (Docker mode)
- **Output**: Structured JSON with title and hierarchical headings
- **Hardware**: CPU-only execution (no GPU required)

## 🚀 Features

- ✅ **Document Title Extraction**: Automatically identifies the main document title
- ✅ **Hierarchical Headings**: Extracts H1, H2, H3, etc. with proper hierarchy
- ✅ **Page Number Mapping**: Associates each heading with its page number
- ✅ **CPU-Only Processing**: Optimized for CPU execution without GPU dependencies
- ✅ **Offline Operation**: No internet connection required at runtime
- ✅ **Docker Support**: Containerized solution with offline model caching
- ✅ **JSON Output**: Structured output in required format
- ✅ **Error Handling**: Robust error handling and validation
- ✅ **Post-Processing**: Automatic JSON formatting and validation

## 🐳 Docker Quick Start (Recommended)

The easiest way to run the solution is using Docker, which handles all dependencies and works completely offline:

### 1. Build the Docker Image

```bash
# Clone/navigate to the project directory
cd Challenge_1a

# Build the Docker image (requires internet for downloading models)
docker build -t round1a-solution:test .
```

**Note**: The build process downloads HuggingFace models during image creation, so internet access is required only during the build phase.

### 2. Run in Offline Mode

```bash
# Windows PowerShell
docker run --rm -v "${PWD}\input:/app/input:ro" -v "${PWD}\output:/app/output" --network none round1a-solution:test

# Linux/macOS
docker run --rm -v "$(pwd)/input:/app/input:ro" -v "$(pwd)/output:/app/output" --network none round1a-solution:test
```

### 3. Input/Output Setup

```bash
# Place your PDF files in the input directory
mkdir input output
cp your_document.pdf input/

# After running, check the output directory
ls output/
```

### Docker Command Explanation

- `--rm`: Remove container after execution
- `-v "${PWD}\input:/app/input:ro"`: Mount input directory as read-only
- `-v "${PWD}\output:/app/output"`: Mount output directory for results
- `--network none`: Run in complete offline mode (no internet access)

## 📦 Manual Installation & Setup

If you prefer to run without Docker:

### Prerequisites

1. **Python 3.8+**
2. **Poppler Utils** (for PDF processing)

#### Install Poppler Utils

**Windows:**
```bash
# Using winget (recommended)
winget install oschwartz10612.Poppler_Microsoft.Winget.Source

# Or download from: https://github.com/oschwartz10612/poppler-windows/releases
# Extract to C:\poppler and add C:\poppler\bin to PATH
```

**macOS:**
```bash
brew install poppler
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install poppler-utils
```

**Linux (CentOS/RHEL):**
```bash
sudo yum install poppler-utils
```

### Python Environment Setup

1. **Create a virtual environment (recommended):**
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate
```

2. **Install Python dependencies:**
```bash
# Install core dependencies
pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
pip install detectron2 -f https://dl.fbaipublicfiles.com/detectron2/wheels/cpu/torch1.10/index.html
pip install lightgbm
pip install pydantic
pip install lxml
pip install pillow
pip install numpy
pip install pypandoc
pip install struct-eqtable
```

### Verify Installation

```bash
# Test if poppler is installed correctly
pdftohtml -v

# Test if Python dependencies are working
python -c "import torch; import detectron2; import lightgbm; print('All dependencies installed successfully!')"
```

## 🏃‍♂️ Manual Usage

### Basic Usage

```bash
# Process a PDF and print output to console
python round1a_solution.py document.pdf

# Process a PDF with pretty-printed output
python round1a_solution.py document.pdf --pretty

# Process a PDF and save to file
python round1a_solution.py document.pdf -o output.json
```

### Example Output

```json
{
  "title": "National Education Policy 2020",
  "outline": [
    {
      "level": "H1",
      "text": "PART II. HIGHER EDUCATION",
      "page": 2
    },
    {
      "level": "H2",
      "text": "Introduction",
      "page": 4
    },
    {
      "level": "H3",
      "text": "1. Early Childhood Care and Education: The Foundation of Learning",
      "page": 8
    }
  ]
}
```

## 📁 Project Structure

```
Challenge_1a/
├── README.md                    # This file
├── Dockerfile                   # Docker configuration with offline model caching
├── docker_entrypoint.py         # Docker container entrypoint
├── requirements.txt             # Python dependencies
├── round1a_solution.py          # Main solution script
├── round1a_solution_optimized.py # Optimized version
├── post_process_output.py       # JSON post-processing utilities
├── run_with_post_processing.py  # Wrapper with automatic post-processing
├── input/                       # Input PDF files directory
├── output/                      # Output JSON files directory
├── models/                      # Pre-trained ML models
│   ├── token_type_lightgbm.model
│   ├── paragraph_extraction_lightgbm.model
│   ├── config.json
│   └── .huggingface/           # Cached HuggingFace models (Docker)
├── src/                         # Core implementation
│   ├── pdf_layout_analysis/     # PDF layout analysis
│   ├── toc/                     # Table of contents extraction
│   ├── pdf_features/           # PDF feature extraction
│   ├── fast_trainer/           # Fast ML model training
│   ├── pdf_tokens_type_trainer/ # Token type classification
│   │   └── download_models.py   # Model download with offline support
│   └── ditod/                  # Document understanding models
└── xmls/                       # Temporary XML files
```

## 🧠 Technical Architecture

### Docker Offline Architecture

The Docker solution implements a two-phase approach for offline operation:

1. **Build Phase (Online)**: Downloads and caches HuggingFace models
2. **Runtime Phase (Offline)**: Uses cached models without internet access

### Model Caching System

The `src/pdf_tokens_type_trainer/download_models.py` module automatically:
- Detects if running in Docker environment
- Uses cached models when available (`/app/models/.huggingface`)
- Falls back to online download if cache is not available
- Enables `local_files_only=True` for offline operation

### Processing Pipeline

1. **PDF Analysis**: Fast layout analysis using optimized ML models
2. **Segment Detection**: Identify text segments and their types
3. **TOC Extraction**: Extract table of contents with hierarchy
4. **Format Conversion**: Convert to Round 1A required JSON format
5. **Post-Processing**: Validate and format output

### Key Components

- **`analyze_pdf_fast()`**: Optimized PDF layout analysis
- **`extract_table_of_contents()`**: Hierarchical heading extraction
- **`Round1ASolutionEngine`**: Main processing engine
- **`JSONPostProcessor`**: Output formatting and validation

### ML Models Used

- **LightGBM Models**: Fast tree-based models for token classification
- **HuggingFace Models**: Cached during Docker build for offline use
- **Pre-trained Weights**: Optimized for document structure extraction
- **CPU-Optimized**: No GPU dependencies

## ⚡ Performance Optimization

### CPU-Only Execution

The solution is explicitly configured for CPU-only execution:

```python
# Force CPU-only execution
os.environ["CUDA_VISIBLE_DEVICES"] = ""  # Disable GPU
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"  # Reduce TensorFlow logging
```

### Performance Targets

- **Processing Time**: <10 seconds for 50 pages
- **Memory Usage**: <16GB RAM
- **Accuracy**: High-quality heading extraction
- **Reliability**: Robust error handling

## 🧪 Testing

### Docker Testing

```bash
# Test with sample documents using Docker
docker run --rm -v "${PWD}\input:/app/input:ro" -v "${PWD}\output:/app/output" --network none round1a-solution:test

# Check processing results
cat output/your_document.json
```

### Manual Testing

```bash
# Test with sample document
python round1a_solution.py test_pdfs/NEP.pdf --pretty

# Test performance
time python round1a_solution.py test_pdfs/NEP.pdf

# Test with different document types
python round1a_solution.py test_pdfs/table.pdf --pretty
python round1a_solution.py test_pdfs/formula.pdf --pretty
```

## 🔍 Troubleshooting

### Docker Issues

1. **Build fails downloading models**
   ```bash
   # Ensure internet connection during build
   docker build --no-cache -t round1a-solution:test .
   ```

2. **"Permission denied" errors**
   ```bash
   # On Linux/macOS, ensure proper permissions
   chmod -R 755 input output
   ```

3. **Container fails to start**
   ```bash
   # Check if directories exist
   mkdir -p input output
   
   # Verify Docker build succeeded
   docker images | grep round1a-solution
   ```

### Common Issues

1. **"pdftohtml not found" (Manual setup)**
   ```bash
   # Install poppler-utils
   # Windows: winget install oschwartz10612.Poppler_Microsoft.Winget.Source
   # macOS: brew install poppler
   # Linux: sudo apt-get install poppler-utils
   ```

2. **"CUDA out of memory"**
   - The solution is configured for CPU-only execution
   - Check that `CUDA_VISIBLE_DEVICES=""` is set in the code

3. **Slow processing**
   - Ensure you're using the fast analysis pipeline
   - Check system memory availability
   - Consider processing smaller documents

4. **Invalid JSON output**
   - Use the post-processing wrapper: `run_with_post_processing.py`
   - Check input PDF format and quality

5. **Import errors (Manual setup)**
   ```bash
   # Make sure you're in the correct directory
   cd /path/to/Challenge_1a
   
   # Check if src directory is in Python path
   python -c "import sys; print('src' in sys.path)"
   ```

### Error Messages

- **"PDF file not found"**: Check file path and permissions
- **"File must be a PDF"**: Ensure file has .pdf extension
- **"Processing took Xs (target: <10s)"**: Performance warning
- **"Error processing PDF"**: Check PDF format and content

## 📊 Usage Options

### Docker Usage

```bash
# Basic Docker run (offline mode)
docker run --rm -v "${PWD}\input:/app/input:ro" -v "${PWD}\output:/app/output" --network none round1a-solution:test

# Docker run with custom directories (Windows)
docker run --rm -v "C:\path\to\pdfs:/app/input:ro" -v "C:\path\to\output:/app/output" --network none round1a-solution:test

# Docker run with custom directories (Linux/macOS)
docker run --rm -v "/path/to/pdfs:/app/input:ro" -v "/path/to/output:/app/output" --network none round1a-solution:test
```

### Manual Command Line Arguments

```bash
python round1a_solution.py [OPTIONS] PDF_FILE

Arguments:
  PDF_FILE                    Path to the PDF file to process

Options:
  -o, --output FILE           Output JSON file (default: print to stdout)
  --pretty                    Pretty print JSON output
  -h, --help                  Show help message
```

### Advanced Manual Usage

```bash
# Process with custom output formatting
python round1a_solution.py document.pdf --pretty -o structured_output.json

# Use post-processing wrapper for guaranteed format compliance
python run_with_post_processing.py document.pdf output.json

# Post-process existing JSON output
python post_process_output.py raw_output.json -o formatted_output.json
```

## 📄 Output Format

### Required JSON Schema

```json
{
  "title": "string",
  "outline": [
    {
      "level": "string",    // H1, H2, H3, etc.
      "text": "string",     // Heading text
      "page": "integer"     // Page number
    }
  ]
}
```

### Field Descriptions

- **title**: Main document title (string)
- **outline**: Array of heading objects
  - **level**: Heading level (H1, H2, H3, etc.)
  - **text**: Heading text content
  - **page**: Page number where heading appears

## 🔧 Configuration

### Environment Variables

The solution automatically sets these environment variables for optimal performance:

```python
os.environ["CUDA_VISIBLE_DEVICES"] = ""  # Force CPU-only execution
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"  # Reduce TensorFlow logging
```

### Performance Tuning

- **Memory Usage**: The solution automatically manages memory usage
- **Processing Time**: Optimized for <10 seconds per 50 pages
- **CPU Utilization**: Efficiently uses available CPU cores

## 🚀 Deployment

### Docker Deployment (Recommended)

```bash
# Build the production image
docker build -t round1a-solution:latest .

# Run in production with mounted volumes
docker run --rm \
  -v "/path/to/input:/app/input:ro" \
  -v "/path/to/output:/app/output" \
  --network none \
  round1a-solution:latest
```

### Manual Production Setup

1. **Install dependencies** (see Installation section)
2. **Verify poppler installation**
3. **Test with sample documents**
4. **Configure environment variables if needed**

## 📈 Performance Benchmarks

### Docker Test Results

| Document | Pages | Processing Time | Memory Usage | Status |
|----------|-------|----------------|--------------|---------|
| 50_pg.pdf | 50 | ~3.8s | ~560MB | ✅ Excellent |
| NEP.pdf | 66 | ~11.5s | ~718MB | ⚠️ Acceptable |

### Manual Setup Results

| Document | Pages | Processing Time | Memory Usage | Status |
|----------|-------|----------------|--------------|---------|
| NEP.pdf | 66 | ~17s | ~8GB | ⚠️ Slow |
| regular.pdf | 10 | ~3s | ~2GB | ✅ Good |

*Note: Docker performance is significantly better due to optimized dependencies*

## 🤝 Contributing

This solution is designed for the Adobe India Hackathon Round 1A. For improvements:

1. Ensure Docker offline operation is maintained
2. Keep CPU-only execution
3. Maintain performance targets (<10s for 50 pages)
4. Follow the required JSON output format

## 📄 License

This project is developed for the Adobe India Hackathon Round 1A competition.

## 🙏 Acknowledgments

- Adobe India Hackathon organizers
- Open-source PDF processing libraries
- Machine learning model contributors
- HuggingFace for model hosting

---

## 🆘 Support

If you encounter issues:

1. **Use Docker first** - it handles all dependencies automatically
2. Check the troubleshooting section above
3. For Docker issues, ensure proper volume mounting
4. For manual setup, verify all dependencies are installed correctly
5. Test with the provided sample files

**Note**: Docker is the recommended approach as it ensures consistent offline operation and better performance. Manual setup is provided for development purposes.

**Docker Benefits**:
- ✅ Offline operation guaranteed
- ✅ All dependencies pre-installed
- ✅ Consistent performance across systems
- ✅ No manual dependency management
- ✅ Isolated execution environment 
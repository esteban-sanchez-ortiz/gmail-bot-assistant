#!/bin/bash
set -e

echo "=== Gmail Bot Assistant - Environment Setup ==="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Warning: This script is optimized for macOS. Some steps may differ on other systems."
fi

# Step 1: Check Python version
echo "[1/6] Checking Python version..."
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed. Please install Python 3.11 or higher."
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo "✓ Python $PYTHON_VERSION found"
echo ""

# Step 2: Create virtual environment
echo "[2/6] Setting up virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "✓ Virtual environment created"
else
    echo "✓ Virtual environment already exists"
fi
echo ""

# Step 3: Install dependencies
echo "[3/6] Installing dependencies..."
source venv/bin/activate
pip install --upgrade pip > /dev/null 2>&1
pip install -r requirements.txt > /dev/null 2>&1
pip install -r requirements-dev.txt > /dev/null 2>&1
echo "✓ Dependencies installed"
echo ""

# Step 4: Check/Install Ollama
echo "[4/6] Checking Ollama installation..."
if ! command -v ollama &> /dev/null; then
    echo "Ollama not found. Installing via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install ollama
        echo "✓ Ollama installed"
    else
        echo "Error: Homebrew not found. Please install Ollama manually:"
        echo "  Visit: https://ollama.com/download"
        exit 1
    fi
else
    echo "✓ Ollama already installed"
fi
echo ""

# Step 5: Pull embedding model
echo "[5/6] Pulling Ollama embedding model..."
if ollama list | grep -q "nomic-embed-text"; then
    echo "✓ nomic-embed-text model already pulled"
else
    echo "Pulling nomic-embed-text (this may take a few minutes)..."
    ollama pull nomic-embed-text
    echo "✓ Model pulled successfully"
fi
echo ""

# Step 6: Setup configuration
echo "[6/6] Setting up configuration..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "✓ Created .env file from template"
else
    echo "✓ .env file already exists"
fi

if [ ! -f "credentials.json" ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠️  Gmail API Setup Required"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "To get Gmail API credentials:"
    echo "1. Go to: https://console.cloud.google.com/"
    echo "2. Create a new project (or select existing)"
    echo "3. Enable Gmail API"
    echo "4. Go to 'Credentials' → 'Create Credentials' → 'OAuth client ID'"
    echo "5. Choose 'Desktop app' as application type"
    echo "6. Download the JSON file"
    echo "7. Save it as 'credentials.json' in this directory"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo "✓ credentials.json found"
fi
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "1. Activate virtual environment: source venv/bin/activate"
echo "2. Place credentials.json in this directory (if not already done)"
echo "3. Start Ollama server: ollama serve"
echo "4. Run the bot: python cli.py --help"
echo ""

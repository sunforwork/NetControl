#!/bin/bash

# SUN.sh - Convert all txt files in docs directory to HTML
# Title: YuChen联网控分发平台
# Encoding: UTF-8 with line break support
# Usage: ./SUN.sh [--help]
# New features:
# - Copy WAF.html (placed next to this script) into html_output root and into every output subdirectory as WAF.html and index.html to prevent directory listing.
# - Generated HTML include a JS-only browser redirect to WAF.html so API consumers (curl, fetch) still receive the HTML, but browsers will be redirected to the WAF page.

# Set script to exit on any error
set -e

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "SUN.sh - TXT to HTML Converter"
    echo ""
    echo "Description:"
    echo "  Converts all .txt files in the docs directory to HTML files"
    echo "  with UTF-8 encoding and proper line break support."
    echo ""
    echo "Features:"
    echo "  - Title: YuChen联网控分发平台"
    echo "  - UTF-8 encoding support"
    echo "  - Preserves line breaks and formatting"
    echo "  - Responsive design"
    echo "  - Maintains directory structure"
    echo "  - Copies WAF.html into output root and every output subdirectory as WAF.html and index.html to prevent directory scanning"
    echo "  - Adds a JS-only browser redirect in generated HTML to WAF.html (API clients that don't run JS still get raw HTML)"
    echo ""
    echo "Usage:"
    echo "  ./SUN.sh          Convert all txt files in docs directory"
    echo "  ./SUN.sh --help   Show this help message"
    echo ""
    echo "Output:"
    echo "  HTML files are saved to the html_output directory"
    echo ""
    exit 0
fi

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}SUN.sh - TXT to HTML Converter${NC}"
echo "Converting all txt files in docs directory to HTML..."

# Create output directory if it doesn't exist
OUTPUT_DIR="html_output"
mkdir -p "$OUTPUT_DIR"

# Locate script directory and WAF source
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WAF_SOURCE="$SCRIPT_DIR/WAF.html"

# Counter for processed files
processed_count=0

# Function to convert txt to html
convert_txt_to_html() {
    local input_file="$1"
    local relative_path="$2"
    
    # Get filename without extension
    local filename=$(basename "$input_file" .txt)
    
    # Create output path maintaining directory structure
    local output_dir="$OUTPUT_DIR/$(dirname "$relative_path")"
    mkdir -p "$output_dir"
    local output_file="$output_dir/$filename.html"
    
    echo -e "${GREEN}Processing:${NC} $input_file"
    echo -e "${GREEN}Output:${NC} $output_file"
    
    # Read the txt file with UTF-8 encoding and convert to HTML
    # Add a JS-only redirect so browsers are redirected to WAF.html in the same directory.
    # API consumers that do not execute JS will still receive the generated HTML content.
    cat > "$output_file" << EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YuChen联网控分发平台</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
            font-size: 14px;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(45deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            padding: 20px 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .header .subtitle {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .content {
            padding: 30px;
            white-space: pre-wrap;
            word-wrap: break-word;
            font-family: "Consolas", "Monaco", "Courier New", monospace;
            background-color: #f8f9fa;
            border-left: 4px solid #007bff;
            margin: 20px;
            border-radius: 5px;
        }
        
        .footer {
            text-align: center;
            padding: 15px;
            background-color: #f1f3f4;
            color: #666;
            font-size: 12px;
        }
        
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .header h1 {
                font-size: 20px;
            }
            
            .content {
                margin: 10px;
                padding: 20px;
            }
        }
    </style>
    <script>
        // Only executed in browsers (clients that execute JS will be redirected).
        // Non-JS API consumers (curl, fetch) will still receive the generated HTML.
        (function() {
            if (typeof window !== 'undefined' && typeof navigator !== 'undefined') {
                try {
                    // Redirect to WAF.html located in the same directory.
                    // Use replace so history is not cluttered.
                    window.location.replace('WAF.html');
                } catch (e) {
                    // If any error occurs, don't break API consumers.
                    console.error(e);
                }
            }
        })();
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>YuChen联网控分发平台</h1>
            <div class="subtitle">文档内容: $filename.txt</div>
        </div>
        <div class="content">$(cat "$input_file" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g')</div>
        <div class="footer">
            Generated by SUN.sh - $(date '+%Y-%m-%d %H:%M:%S')
        </div>
    </div>
</body>
</html>
EOF
    
    processed_count=$((processed_count + 1))
}

# Find all txt files in docs directory and convert them
if [ -d "docs" ]; then
    while IFS= read -r -d '' file; do
        # Get relative path from docs directory
        relative_path="${file#docs/}"
        convert_txt_to_html "$file" "$relative_path"
    done < <(find docs -name "*.txt" -type f -print0)
    
    echo ""
    echo -e "${GREEN}Conversion completed!${NC}"
    echo -e "${GREEN}Processed files: $processed_count${NC}"
    echo -e "${GREEN}Output directory: $OUTPUT_DIR${NC}"
    
    if [ $processed_count -eq 0 ]; then
        echo -e "${RED}Warning: No txt files found in docs directory${NC}"
    fi
else
    echo -e "${RED}Error: docs directory not found${NC}"
    exit 1
fi

# Copy WAF.html to output root and into every output subdirectory as both WAF.html and index.html
if [ -f "$WAF_SOURCE" ]; then
    echo -e "${BLUE}Copying WAF.html into output directories...${NC}"
    # Copy to output root as requested
    cp -f "$WAF_SOURCE" "$OUTPUT_DIR/WAF.html"
    # Iterate all directories under OUTPUT_DIR (including root) and copy WAF.html as WAF.html and index.html
    while IFS= read -r -d '' dir; do
        cp -f "$WAF_SOURCE" "$dir/WAF.html"
        cp -f "$WAF_SOURCE" "$dir/index.html"
    done < <(find "$OUTPUT_DIR" -type d -print0)
    echo -e "${GREEN}WAF.html copied to $OUTPUT_DIR and all subdirectories as WAF.html and index.html.${NC}"
else
    echo -e "${RED}Warning: WAF.html not found next to the script ($WAF_SOURCE). Skipping WAF copying.${NC}"
    echo -e "${YELLOW}Note: To enable directory protection and browser redirect target, place WAF.html beside this script and re-run.${NC}" 2>/dev/null || true
fi

echo -e "${BLUE}Done!${NC}"

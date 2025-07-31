#!/bin/bash

# Script to create language files for docs and html subdirectories
# Creates files with pattern: {folder_name}-{language}.md in docs/
# Creates files with pattern: {folder_name}-{language}.html in html/

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Creating language files for docs and html subdirectories...${NC}"

# Check if we're in the agreement-translations directory
if [[ ! -d "aurigraph-farmer-agreement" ]]; then
    echo -e "${RED}Error: Please run this script from the agreement-translations directory${NC}"
    exit 1
fi

# Languages to create files for
LANGUAGES=("english" "kannada" "telugu" "tamil" "malayalam")

# Function to create language files for docs subdirectory
create_docs_files() {
    local folder_name="$1"
    local docs_path="$2"

    echo -e "${BLUE}Processing docs subdirectory for: $folder_name${NC}"

    # Create docs directory if it doesn't exist
    if [[ ! -d "$docs_path" ]]; then
        mkdir -p "$docs_path"
        echo -e "${GREEN}  Created docs directory${NC}"
    fi

    # Create language files for each language in docs/
    for language in "${LANGUAGES[@]}"; do
        local file_name="${folder_name}-${language}.md"
        local file_path="${docs_path}/${file_name}"

        # Check if file already exists
        if [[ -f "$file_path" ]]; then
            echo -e "${YELLOW}  File already exists: docs/$file_name${NC}"
        else
            # Create the file with a basic markdown template
            cat > "$file_path" << EOF
# ${folder_name} - ${language^}

## Agreement Details

This document contains the ${language^} version of the ${folder_name} agreement.

### Content

[Content will be added here]

### Version

Version: 1.0
Language: ${language^}
Created: $(date '+%Y-%m-%d %H:%M:%S')
Type: Documentation

---
EOF
            echo -e "${GREEN}  Created: docs/$file_name${NC}"
        fi
    done
    echo ""
}

# Function to create language files for html subdirectory
create_html_files() {
    local folder_name="$1"
    local html_path="$2"

    echo -e "${BLUE}Processing html subdirectory for: $folder_name${NC}"

    # Create html directory if it doesn't exist
    if [[ ! -d "$html_path" ]]; then
        mkdir -p "$html_path"
        echo -e "${GREEN}  Created html directory${NC}"
    fi

    # Create language files for each language in html/
    for language in "${LANGUAGES[@]}"; do
        local file_name="${folder_name}-${language}.html"
        local file_path="${html_path}/${file_name}"

        # Check if file already exists
        if [[ -f "$file_path" ]]; then
            echo -e "${YELLOW}  File already exists: html/$file_name${NC}"
        else
            # Create the file with a basic HTML template
            cat > "$file_path" << EOF
<!DOCTYPE html>
<html lang="${language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${folder_name} - ${language^}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        h2 {
            color: #555;
            margin-top: 30px;
        }
        .version-info {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-top: 30px;
            border-left: 4px solid #007bff;
        }
        .content-placeholder {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${folder_name} - ${language^}</h1>

        <h2>Agreement Details</h2>
        <p>This document contains the ${language^} version of the ${folder_name} agreement.</p>

        <h2>Content</h2>
        <div class="content-placeholder">
            <strong>Content will be added here</strong>
        </div>

        <div class="version-info">
            <h3>Version Information</h3>
            <p><strong>Version:</strong> 1.0</p>
            <p><strong>Language:</strong> ${language^}</p>
            <p><strong>Created:</strong> $(date '+%Y-%m-%d %H:%M:%S')</p>
            <p><strong>Type:</strong> HTML Document</p>
        </div>
    </div>
</body>
</html>
EOF
            echo -e "${GREEN}  Created: html/$file_name${NC}"
        fi
    done
    echo ""
}

# Process each folder
for folder in aurigraph-*/; do
    if [[ -d "$folder" ]]; then
        # Remove trailing slash to get folder name
        folder_name=$(basename "$folder")
        echo -e "${GREEN}Processing folder: $folder_name${NC}"

        # Create files for docs subdirectory
        docs_path="${folder}docs"
        create_docs_files "$folder_name" "$docs_path"

        # Create files for html subdirectory
        html_path="${folder}html"
        create_html_files "$folder_name" "$html_path"

        echo -e "${GREEN}Completed processing: $folder_name${NC}"
        echo "----------------------------------------"
    fi
done

echo -e "${GREEN}Subdirectory language file creation completed!${NC}"
echo -e "${YELLOW}Summary:${NC}"
echo "Created files for each folder in docs/ and html/ subdirectories:"
echo ""
echo "docs/ subdirectory:"
echo "  - {folder_name}-english.md"
echo "  - {folder_name}-kannada.md"
echo "  - {folder_name}-telugu.md"
echo "  - {folder_name}-tamil.md"
echo "  - {folder_name}-malayalam.md"
echo ""
echo "html/ subdirectory:"
echo "  - {folder_name}-english.html"
echo "  - {folder_name}-kannada.html"
echo "  - {folder_name}-telugu.html"
echo "  - {folder_name}-tamil.html"
echo "  - {folder_name}-malayalam.html"